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
}
