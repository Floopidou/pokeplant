import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["waterTab", "potTab", "waterPanel", "potPanel"]

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
