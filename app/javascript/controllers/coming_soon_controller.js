import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay"]

  open(event) {
    event.preventDefault()
    this.overlayTarget.classList.add("is-open")
  }

  close() {
    this.overlayTarget.classList.remove("is-open")
  }
}
