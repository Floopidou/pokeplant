import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button", "messages"]

  connect() {
    this.inputTarget.addEventListener("keydown", this.handleKeydown.bind(this))
  }

  handleKeydown(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.element.querySelector("form").requestSubmit()
    }
  }


  submit() {
    const content = this.inputTarget.value.trim()
    if (!content) return

    // Désactiver le bouton
    this.buttonTarget.disabled = true
    this.buttonTarget.innerHTML = "⏳"

    // Ajouter l'indicateur de typing
    this.showTypingIndicator()
  }

  showTypingIndicator() {
    const container = this.element.closest('.chat-container')
    const avatarPath = container?.dataset.plantAvatar || ""
    const typingHTML = `
      <div class="chat-message chat-message--plant" id="typing-indicator">
        <div class="chat-message-avatar">
          <img src="${avatarPath}" alt="Plant" class="chat-message-avatar-img">
        </div>
        <div class="chat-bubble chat-bubble--plant">
          <div class="chat-typing">
            <span class="chat-typing-dot"></span>
            <span class="chat-typing-dot"></span>
            <span class="chat-typing-dot"></span>
          </div>
        </div>
      </div>
    `
    this.messagesTarget.insertAdjacentHTML("beforeend", typingHTML)
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  // Appelé quand Turbo reçoit la réponse
  removeTypingIndicator() {
    const indicator = document.getElementById("typing-indicator")
    if (indicator) indicator.remove()

    // Réactiver le bouton
    this.buttonTarget.disabled = false
    this.buttonTarget.innerHTML = "✨ Envoyer"
  }
}
