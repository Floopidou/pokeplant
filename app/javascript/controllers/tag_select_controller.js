import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "tile", "counter"]
  static values = { max: { type: Number, default: 3 } }

  update() {
    const checked = this.checkboxTargets.filter(cb => cb.checked)
    const count = checked.length

    this.counterTarget.textContent = `${count} / ${this.maxValue}`

    this.checkboxTargets.forEach((cb, i) => {
      const tile = this.tileTargets[i]
      if (cb.checked) {
        tile.classList.add("is-selected")
        tile.classList.remove("is-disabled")
        cb.disabled = false
      } else if (count >= this.maxValue) {
        tile.classList.remove("is-selected")
        tile.classList.add("is-disabled")
        cb.disabled = true
      } else {
        tile.classList.remove("is-selected", "is-disabled")
        cb.disabled = false
      }
    })
  }

  checkSubmit(event) {
    const count = this.checkboxTargets.filter(cb => cb.checked).length
    const missing = this.maxValue - count

    if (missing > 0) {
      event.preventDefault()
      const msg = missing === this.maxValue
        ? `Please check ${this.maxValue} words.`
        : `Please check ${missing} more ${missing === 1 ? "word" : "words"}.`
      this.#showFlash(msg)
    }
  }

  #showFlash(message) {
    const existing = document.querySelector(".pp-flash--js")
    if (existing) existing.remove()

    const el = document.createElement("div")
    el.className = "pp-flash pp-flash--alert pp-flash--js"
    el.textContent = message
    document.body.appendChild(el)

    setTimeout(() => el.remove(), 4000)
  }
}
