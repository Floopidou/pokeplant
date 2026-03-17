import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "bell"]
  static values  = { count: Number }

  connect() {
    if (this.countValue > 0 && this.hasBellTarget) {
      this.bellTarget.classList.add("is-shaking")
      this.bellTarget.addEventListener("animationend", () => {
        this.bellTarget.classList.remove("is-shaking")
      }, { once: true })

      document.dispatchEvent(new CustomEvent("reminders:alert"))
    }
  }

  openAudioSettings() {
    document.dispatchEvent(new CustomEvent("audio:open-settings"))
  }

  open(event) {
    event.preventDefault()
    this.overlayTarget.classList.add("is-open")
  }

  close() {
    this.overlayTarget.classList.remove("is-open")
  }

  backdropClick(event) {
    if (event.target === this.overlayTarget) {
      this.close()
    }
  }
}
