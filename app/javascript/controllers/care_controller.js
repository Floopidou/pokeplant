import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["waterTab", "potTab", "waterPanel", "potPanel", "petForm", "waterFill", "repotFill"]

  connect() {
    const frame = document.getElementById("care-bottom")
    if (frame) {
      this._onFrameRender = () => {
        requestAnimationFrame(() => {
          if (this.hasWaterFillTarget) this._animateFill(this.waterFillTarget)
          if (this.hasRepotFillTarget) this._animateFill(this.repotFillTarget)
        })
      }
      frame.addEventListener("turbo:frame-render", this._onFrameRender)
    }
  }

  disconnect() {
    const frame = document.getElementById("care-bottom")
    if (frame && this._onFrameRender) {
      frame.removeEventListener("turbo:frame-render", this._onFrameRender)
    }
  }

  _animateFill(rect) {
    const target = parseFloat(rect.dataset.fillWidth)
    rect.style.transition = "none"
    rect.style.width = "0"
    requestAnimationFrame(() => requestAnimationFrame(() => {
      rect.style.transition = "width 1.4s cubic-bezier(0.25, 0.46, 0.45, 0.94)"
      rect.style.width = `${target}`
    }))
  }

  startRub(event) {
    event.preventDefault()
    this.rubbing = true
    this.rubDistance = 0
    this.rubPetted = false
    const point = event.touches ? event.touches[0] : event
    this.lastX = point.clientX
    this.lastY = point.clientY
  }

  trackRub(event) {
    if (!this.rubbing || this.rubPetted) return
    const point = event.touches ? event.touches[0] : event
    const dx = point.clientX - this.lastX
    const dy = point.clientY - this.lastY
    this.rubDistance += Math.sqrt(dx * dx + dy * dy)
    this.lastX = point.clientX
    this.lastY = point.clientY
    if (this.rubDistance > 50) {
      this.rubPetted = true
      this.triggerPet()
    }
  }

  triggerPet() {
    const avatar = this.element.querySelector(".care-avatar")
    avatar.classList.add("care-avatar--petted")
    avatar.addEventListener("animationend", () => avatar.classList.remove("care-avatar--petted"), { once: true })

    const zone = this.element.querySelector(".care-avatar-zone")
    for (let i = 0; i < 6; i++) {
      setTimeout(() => {
        const heart = document.createElement("div")
        heart.className = "care-pet-heart"
        heart.innerHTML = `<svg width="22" height="19" viewBox="0 0 32 28" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0.964844 11.0947L15.9185 26.0483L29.9074 11.577V5.30615L25.566 1.44714H20.2599L15.9185 6.27091L11.5771 1.44714H5.78861L0.964844 6.27091V11.0947Z" fill="#F2A0B0"/></svg>`
        heart.style.left = `${15 + Math.random() * 70}%`
        heart.style.bottom = `${50 + Math.random() * 30}%`
        zone.appendChild(heart)
        heart.addEventListener("animationend", () => heart.remove())
      }, i * 100)
    }

    this.element.dispatchEvent(new CustomEvent("plant:petted", { bubbles: true }))
    setTimeout(() => this.petFormTarget.requestSubmit(), 700)
  }

  stopRub() {
    this.rubbing = false
    this.rubDistance = 0
  }

  showWater() {
    this.waterPanelTarget.style.display = "flex"
    this.potPanelTarget.style.display   = "none"
    this.waterTabTarget.classList.add("care-tab--active")
    this.waterTabTarget.classList.remove("care-tab--inactive")
    this.waterTabTarget.innerHTML = '<span class="care-tab-arrow">▸</span> WATER'
    this.potTabTarget.classList.add("care-tab--inactive")
    this.potTabTarget.classList.remove("care-tab--active")
    this.potTabTarget.textContent = "POT"
  }

  showPot() {
    this.waterPanelTarget.style.display = "none"
    this.potPanelTarget.style.display   = "flex"
    this.potTabTarget.classList.add("care-tab--active")
    this.potTabTarget.classList.remove("care-tab--inactive")
    this.potTabTarget.innerHTML = '<span class="care-tab-arrow">▸</span> POT'
    this.waterTabTarget.classList.add("care-tab--inactive")
    this.waterTabTarget.classList.remove("care-tab--active")
    this.waterTabTarget.textContent = "WATER"
  }
}
