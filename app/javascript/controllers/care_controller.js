import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["waterTab", "potTab", "waterPanel", "potPanel", "petForm"]

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
      this.petFormTarget.requestSubmit()
    }
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
