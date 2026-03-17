import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String
  }

  connect() {
    this.modal = null
  }

  open(event) {
    event.preventDefault()
    this.createModal()
  }

  createModal() {
    if (this.modal) this.modal.remove()

    this.modal = document.createElement("div")
    this.modal.classList.add("photo-modal-overlay")
    this.modal.innerHTML = `
      <div class="photo-modal">
        <div class="photo-modal-icon">📸</div>
        <h2 class="photo-modal-title">Add a photo</h2>
        <div class="photo-modal-buttons">
          <button type="button" class="pixel-btn pixel-btn--green photo-modal-btn" id="take-photo-btn">
            📷 Take a photo
          </button>
          <button type="button" class="pixel-btn pixel-btn--pink photo-modal-btn" id="choose-photo-btn">
            🖼️ Choose from gallery
          </button>
          <button type="button" class="pixel-btn pixel-btn--cancel photo-modal-btn" id="cancel-photo-btn">
            Cancel
          </button>
        </div>
        <input type="file" accept="image/*" capture="environment" id="camera-input" style="display: none;">
        <input type="file" accept="image/*" id="gallery-input" style="display: none;">
      </div>
    `

    document.body.appendChild(this.modal)

    this.modal.querySelector("#take-photo-btn").addEventListener("click", () => this.takePhoto())
    this.modal.querySelector("#choose-photo-btn").addEventListener("click", () => this.choosePhoto())
    this.modal.querySelector("#cancel-photo-btn").addEventListener("click", () => this.close())
    this.modal.addEventListener("click", (e) => {
      if (e.target === this.modal) this.close()
    })

    this.modal.querySelector("#camera-input").addEventListener("change", (e) => this.handleFile(e))
    this.modal.querySelector("#gallery-input").addEventListener("change", (e) => this.handleFile(e))
  }

  takePhoto() {
    this.modal.querySelector("#camera-input").click()
  }

  choosePhoto() {
    this.modal.querySelector("#gallery-input").click()
  }

  handleFile(event) {
    const file = event.target.files[0]
    if (file) {
      this.sendPhoto(file)
      this.close()
    }
  }

  sendPhoto(file) {
    // Afficher la photo immédiatement
    const imageUrl = URL.createObjectURL(file)
    this.showTempPhoto(imageUrl)

    // Afficher le typing indicator
    this.showTypingIndicator()

    // Envoyer la photo au serveur
    const formData = new FormData()
    formData.append("message[image]", file)
    formData.append("message[content]", "")

    const csrfToken = document.querySelector("meta[name='csrf-token']").content

    fetch(this.urlValue, {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: formData
    })
    .then(response => response.text())
    .then(html => {
      document.getElementById("temp-photo-message")?.remove()
      document.getElementById("typing-indicator")?.remove()
      Turbo.renderStreamMessage(html)
    })
    .catch(error => {
      console.error("Error:", error)
      document.getElementById("typing-indicator")?.remove()
    })
  }

  showTempPhoto(imageUrl) {
    const messagesContainer = document.getElementById("chat-messages")
    const now = new Date()
    const time = now.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: false })

    const photoMessageHTML = `
      <div class="chat-message chat-message--user" id="temp-photo-message">
        <div class="chat-bubble chat-bubble--user chat-bubble--photo">
          <img src="${imageUrl}" alt="Photo" class="chat-photo">
          <span class="chat-time">${time}</span>
        </div>
      </div>
    `

    messagesContainer.insertAdjacentHTML("beforeend", photoMessageHTML)
    messagesContainer.scrollTop = messagesContainer.scrollHeight
  }

  showTypingIndicator() {
    const messagesContainer = document.getElementById("chat-messages")
    const container = document.querySelector('.chat-container')
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
    messagesContainer.insertAdjacentHTML("beforeend", typingHTML)
    messagesContainer.scrollTop = messagesContainer.scrollHeight
  }

  close() {
    if (this.modal) {
      this.modal.remove()
      this.modal = null
    }
  }
}
