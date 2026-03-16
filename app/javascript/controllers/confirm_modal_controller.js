import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    title: { type: String, default: "Confirm" },
    message: { type: String, default: "Are you sure ?" },
    url: String
  }

  connect() {
    this.modal = null
  }

  open(event) {
    event.preventDefault()
    event.stopPropagation()
    this.createModal()
  }

  createModal() {
    // Supprimer une modal existante
    if (this.modal) this.modal.remove()

    this.modal = document.createElement("div")
    this.modal.classList.add("confirm-modal-overlay")
    this.modal.innerHTML = `
      <div class="confirm-modal">
        <h2 class="confirm-modal-title">${this.titleValue}</h2>
        <p class="confirm-modal-message">${this.messageValue}</p>
        <div class="confirm-modal-buttons">
          <button type="button" class="pixel-btn pixel-btn--cancel" id="modal-cancel">
            Cancel
          </button>
          <button type="button" class="pixel-btn pixel-btn--pink" id="modal-confirm">
            Delete
          </button>
        </div>
      </div>
    `

    document.body.appendChild(this.modal)

    // Ajouter les event listeners
    this.modal.querySelector("#modal-cancel").addEventListener("click", () => this.cancel())
    this.modal.querySelector("#modal-confirm").addEventListener("click", () => this.confirm())
    this.modal.addEventListener("click", (e) => {
      if (e.target === this.modal) this.cancel()
    })
  }

  confirm() {
    this.closeModal()

    // Créer et soumettre un formulaire dynamique
    const form = document.createElement("form")
    form.method = "POST"
    form.action = this.urlValue

    // Token CSRF
    const csrfToken = document.querySelector("meta[name='csrf-token']").content
    const csrfInput = document.createElement("input")
    csrfInput.type = "hidden"
    csrfInput.name = "authenticity_token"
    csrfInput.value = csrfToken
    form.appendChild(csrfInput)

    // Méthode DELETE
    const methodInput = document.createElement("input")
    methodInput.type = "hidden"
    methodInput.name = "_method"
    methodInput.value = "delete"
    form.appendChild(methodInput)

    document.body.appendChild(form)
    form.submit()
  }

  cancel() {
    this.closeModal()
  }

  closeModal() {
    if (this.modal) {
      this.modal.remove()
      this.modal = null
    }
  }

  disconnect() {
    this.closeModal()
  }
}
