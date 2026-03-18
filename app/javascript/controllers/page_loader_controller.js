import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this._onVisit  = this._showWithDelay.bind(this)
    this._onLoad   = this._hide.bind(this)
    this._onRender = this._hide.bind(this)

    document.addEventListener("turbo:visit",  this._onVisit)
    document.addEventListener("turbo:load",   this._onLoad)
    document.addEventListener("turbo:render", this._onRender)
  }

  disconnect() {
    clearTimeout(this._timer)
    document.removeEventListener("turbo:visit",  this._onVisit)
    document.removeEventListener("turbo:load",   this._onLoad)
    document.removeEventListener("turbo:render", this._onRender)
  }

  _showWithDelay() {
    // Only show after 200ms — fast navigations won't flash the loader
    this._timer = setTimeout(() => {
      this.element.classList.add("is-active")
    }, 200)
  }

  _hide() {
    clearTimeout(this._timer)
    this.element.classList.remove("is-active")
  }
}
