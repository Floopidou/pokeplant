import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values  = { bgmTracks: Array, waterUrl: String, clickUrl: String, remindersUrl: String }
  static targets = ["music", "panel", "musicSlider", "sfxSlider", "muteBtn"]

  connect() {
    // If audio is already playing (reconnect after Turbo navigation), don't reset state
    this.musicStarted = this.hasMusicTarget && !!this.musicTarget.currentSrc
    this.muted        = sessionStorage.getItem("pp_muted")  === "true"
    this.musicVolume  = parseFloat(sessionStorage.getItem("pp_music_vol") ?? "0.5")
    this.sfxVolume    = parseFloat(sessionStorage.getItem("pp_sfx_vol")   ?? "0.7")

    // AudioContext for SFX
    this.ctx          = null
    this.sfxGain      = null
    this._waterBuffer     = null
    this._clickBuffer     = null
    this._remindersBuffer = null

    // Shuffle BGM playlist
    this._playlist   = this._shuffle([...this.bgmTracksValue])
    this._trackIndex = 0

    // Restore slider positions
    if (this.hasMusicSliderTarget) this.musicSliderTarget.value = this.musicVolume
    if (this.hasSfxSliderTarget)   this.sfxSliderTarget.value   = this.sfxVolume
    this._applyMuteUI()

    // Bound listeners (stored for cleanup)
    this._onGlobalClick    = this._handleGlobalClick.bind(this)
    this._onPetted         = () => this._playSfx("pet")
    this._onTrackEnded     = () => this._nextTrack()
    this._onRemindersAlert = () => this._playRemindersSfx()
    this._onOpenSettings   = () => this.openSettings()
    document.addEventListener("click",              this._onGlobalClick)
    document.addEventListener("plant:petted",       this._onPetted)
    document.addEventListener("reminders:alert",    this._onRemindersAlert)
    document.addEventListener("audio:open-settings", this._onOpenSettings)
    if (this.hasMusicTarget) {
      this.musicTarget.addEventListener("ended", this._onTrackEnded)
    }
  }

  disconnect() {
    document.removeEventListener("click",              this._onGlobalClick)
    document.removeEventListener("plant:petted",       this._onPetted)
    document.removeEventListener("reminders:alert",    this._onRemindersAlert)
    document.removeEventListener("audio:open-settings", this._onOpenSettings)
    if (this.hasMusicTarget) {
      this.musicTarget.removeEventListener("ended", this._onTrackEnded)
    }
    if (this.ctx) this.ctx.close()
  }

  // ── Settings panel ───────────────────────────────────────────

  openSettings() {
    this.panelTarget.classList.add("is-open")
  }

  closeSettings() {
    this.panelTarget.classList.remove("is-open")
  }

  // ── Volume controls ──────────────────────────────────────────

  changeMusicVolume(e) {
    this.musicVolume = parseFloat(e.target.value)
    if (this.hasMusicTarget && !this.muted) {
      this.musicTarget.volume = this.musicVolume
    }
    sessionStorage.setItem("pp_music_vol", this.musicVolume)
  }

  changeSfxVolume(e) {
    this.sfxVolume = parseFloat(e.target.value)
    if (this.sfxGain && !this.muted) {
      this.sfxGain.gain.value = this.sfxVolume
    }
    sessionStorage.setItem("pp_sfx_vol", this.sfxVolume)
  }

  toggleMute() {
    this.muted = !this.muted
    sessionStorage.setItem("pp_muted", this.muted)
    this._applyMuteUI()

    if (this.hasMusicTarget) {
      this.musicTarget.volume = this.muted ? 0 : this.musicVolume
    }
    if (this.sfxGain) {
      this.sfxGain.gain.value = this.muted ? 0 : this.sfxVolume
    }
  }

  // ── Internals ────────────────────────────────────────────────

  _applyMuteUI() {
    if (!this.hasMuteBtnTarget) return
    this.muteBtnTarget.classList.toggle("is-muted", this.muted)
    this.muteBtnTarget.textContent = this.muted ? "UNMUTE" : "MUTE ALL"
  }

  _handleGlobalClick(e) {
    // Start music on very first interaction (autoplay policy)
    if (!this.musicStarted) {
      this.musicStarted = true
      this._startMusic()
    }

    const el = e.target.closest("[data-delayed-nav], [data-sound], button, a")
    if (!el) return

    if ("delayedNav" in el.dataset && el.href) {
      e.preventDefault()
      this._playSfx("click")
      const href = el.href
      setTimeout(() => { window.Turbo ? Turbo.visit(href) : (window.location.href = href) }, 350)
      return
    }

    const sound = el.dataset.sound
    if      (sound === "water") this._playSfx("water")
    else if (sound === "repot") this._playSfx("repot")
    else                         this._playSfx("click")
  }

  // ── BGM playlist ─────────────────────────────────────────────

  _startMusic() {
    if (!this.hasMusicTarget || this._playlist.length === 0) return
    if (this.musicTarget.currentSrc && !this.musicTarget.paused) return
    this._playTrack(this._trackIndex)
  }

  _playTrack(index) {
    if (!this.hasMusicTarget || this._playlist.length === 0) return
    this.musicTarget.src    = this._playlist[index % this._playlist.length]
    this.musicTarget.volume = this.muted ? 0 : this.musicVolume
    this.musicTarget.play().catch(() => {})
  }

  _nextTrack() {
    this._trackIndex++
    // Reshuffle when we loop back to start so order is different
    if (this._trackIndex >= this._playlist.length) {
      this._trackIndex = 0
      this._playlist   = this._shuffle(this._playlist)
    }
    this._playTrack(this._trackIndex)
  }

  _shuffle(arr) {
    for (let i = arr.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1))
      ;[arr[i], arr[j]] = [arr[j], arr[i]]
    }
    return arr
  }

  // ── SFX ──────────────────────────────────────────────────────

  _playSfx(type) {
    if (this.muted) return
    this._ensureCtx()

    switch (type) {
      case "click": return this._playClickSfx()
      case "water": return this._playWaterSfx()
      case "repot": return this._synthRepot()
      case "pet":   return this._synthPet()
    }
  }

  // water — real MP3, plays only first 2 seconds
  _playWaterSfx() {
    const DURATION = 2.0
    if (this._waterBuffer) {
      this._playBufferSlice(this._waterBuffer, 0, DURATION)
      return
    }
    fetch(this.waterUrlValue)
      .then(r => r.arrayBuffer())
      .then(ab => this.ctx.decodeAudioData(ab))
      .then(buffer => {
        this._waterBuffer = buffer
        this._playBufferSlice(buffer, 0, DURATION)
      })
      .catch(() => this._synthWater())
  }

  // reminders — real MP3, full duration
  _playRemindersSfx() {
    if (this.muted) return
    this._ensureCtx()
    if (this._remindersBuffer) {
      this._playBufferSlice(this._remindersBuffer, 0, this._remindersBuffer.duration, 0.375)
      return
    }
    fetch(this.remindersUrlValue)
      .then(r => r.arrayBuffer())
      .then(ab => this.ctx.decodeAudioData(ab))
      .then(buffer => {
        this._remindersBuffer = buffer
        this._playBufferSlice(buffer, 0, buffer.duration, 0.375)
      })
      .catch(() => {})
  }

  _playBufferSlice(buffer, offset, duration, gain = 0.75) {
    const PEAK = gain
    const src  = this.ctx.createBufferSource()
    src.buffer = buffer
    const env  = this.ctx.createGain()
    const now  = this.ctx.currentTime
    env.gain.setValueAtTime(PEAK, now)
    env.gain.setValueAtTime(PEAK, now + duration - 0.15)
    env.gain.linearRampToValueAtTime(0, now + duration)
    src.connect(env).connect(this.sfxGain)
    src.start(now, offset, duration)
  }

  _ensureCtx() {
    if (!this.ctx) {
      this.ctx     = new (window.AudioContext || window.webkitAudioContext)()
      this.sfxGain = this.ctx.createGain()
      this.sfxGain.gain.value = this.muted ? 0 : this.sfxVolume
      this.sfxGain.connect(this.ctx.destination)
    }
    if (this.ctx.state === "suspended") this.ctx.resume()
  }

  // click — real MP3
  _playClickSfx() {
    if (this._clickBuffer) {
      this._playBufferSlice(this._clickBuffer, 0, this._clickBuffer.duration)
      return
    }
    fetch(this.clickUrlValue)
      .then(r => r.arrayBuffer())
      .then(ab => this.ctx.decodeAudioData(ab))
      .then(buffer => {
        this._clickBuffer = buffer
        this._playBufferSlice(buffer, 0, buffer.duration)
      })
      .catch(() => {})
  }

  // water fallback — white noise + lowpass, 400 ms
  _synthWater() {
    const now    = this.ctx.currentTime
    const buffer = this.ctx.createBuffer(1, this.ctx.sampleRate * 0.4, this.ctx.sampleRate)
    const data   = buffer.getChannelData(0)
    for (let i = 0; i < data.length; i++) data[i] = Math.random() * 2 - 1

    const src    = this.ctx.createBufferSource()
    src.buffer   = buffer

    const filter = this.ctx.createBiquadFilter()
    filter.type  = "lowpass"
    filter.frequency.value = 800

    const env = this.ctx.createGain()
    env.gain.setValueAtTime(0.75, now)
    env.gain.exponentialRampToValueAtTime(0.001, now + 0.4)

    src.connect(filter).connect(env).connect(this.sfxGain)
    src.start(now)
  }

  // repot — low thud: noise burst + 80 Hz sine, 200 ms
  _synthRepot() {
    const now    = this.ctx.currentTime
    const buffer = this.ctx.createBuffer(1, this.ctx.sampleRate * 0.2, this.ctx.sampleRate)
    const data   = buffer.getChannelData(0)
    for (let i = 0; i < data.length; i++) data[i] = Math.random() * 2 - 1

    const noise   = this.ctx.createBufferSource()
    noise.buffer  = buffer
    const noiseEnv = this.ctx.createGain()
    noiseEnv.gain.setValueAtTime(0.45, now)
    noiseEnv.gain.exponentialRampToValueAtTime(0.001, now + 0.2)

    const osc = this.ctx.createOscillator()
    osc.type = "sine"
    osc.frequency.setValueAtTime(80, now)
    osc.frequency.exponentialRampToValueAtTime(40, now + 0.2)
    const oscEnv = this.ctx.createGain()
    oscEnv.gain.setValueAtTime(0.45, now)
    oscEnv.gain.exponentialRampToValueAtTime(0.001, now + 0.2)

    noise.connect(noiseEnv).connect(this.sfxGain)
    osc.connect(oscEnv).connect(this.sfxGain)
    noise.start(now)
    osc.start(now)
    osc.stop(now + 0.21)
  }

  // pet — kawaii arpège C5→E5→G5, triangle, 100 ms par note
  _synthPet() {
    const now   = this.ctx.currentTime
    const notes = [523.25, 659.25, 783.99] // C5, E5, G5
    notes.forEach((freq, i) => {
      const t   = now + i * 0.1
      const osc = this.ctx.createOscillator()
      const env = this.ctx.createGain()
      osc.type = "triangle"
      osc.frequency.value = freq
      env.gain.setValueAtTime(0.0, t)
      env.gain.linearRampToValueAtTime(0.75, t + 0.02)
      env.gain.exponentialRampToValueAtTime(0.001, t + 0.12)
      osc.connect(env).connect(this.sfxGain)
      osc.start(t)
      osc.stop(t + 0.13)
    })
  }
}
