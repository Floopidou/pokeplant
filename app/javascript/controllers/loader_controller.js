import { Controller } from "@hotwired/stimulus"

// Duration must match the CSS bar-fill animation (6s)
const BAR_DURATION = 6000

export default class extends Controller {
  static targets = ["percent", "status"]

  connect() {
    this._startTime = performance.now()
    this._raf = requestAnimationFrame(this._tick.bind(this))
  }

  disconnect() {
    cancelAnimationFrame(this._raf)
  }

  _tick(now) {
    const elapsed = now - this._startTime
    const raw = Math.min(elapsed / BAR_DURATION, 1)
    const progress = Math.round(this._ease(raw) * 100)

    if (this.hasPercentTarget) {
      this.percentTarget.textContent = `${progress}%`
    }

    if (progress >= 100) {
      if (this.hasStatusTarget) {
        this.statusTarget.textContent = "GARDEN LOADED!"
      }
      // Small extra pause so user sees 100% before redirect
      setTimeout(() => { window.location.href = "/plants" }, 400)
      return
    }

    if (this.hasStatusTarget) {
      this.statusTarget.textContent = this._statusText(progress)
    }

    this._raf = requestAnimationFrame(this._tick.bind(this))
  }

  // Approximates cubic-bezier(0.1, 0, 0.3, 1) used in bar-fill CSS
  _ease(t) {
    if (t < 0.6) return (t / 0.6) * 0.85
    return 0.85 + ((t - 0.6) / 0.4) * 0.15
  }

  _statusText(pct) {
    if (pct < 30)  return "LOADING PLANTS..."
    if (pct < 60)  return "WATERING THE GARDEN..."
    if (pct < 85)  return "ALMOST READY..."
    return "GARDEN LOADED!"
  }
}
