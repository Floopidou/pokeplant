import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track", "dot"]

  connect() {
    this.trackTarget.addEventListener("scroll", this.updateDots.bind(this), { passive: true })
  }

  disconnect() {
    this.trackTarget.removeEventListener("scroll", this.updateDots.bind(this))
  }

  updateDots() {
    const track = this.trackTarget
    const index = Math.round(track.scrollLeft / track.clientWidth)
    this.dotTargets.forEach((dot, i) => {
      dot.classList.toggle("active", i === index)
    })
  }
}
