import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages"]

  connect() {
    this.scrollToBottom()
    this.observeMessages()
  }

  scrollToBottom() {
    const messages = this.messagesTarget
    messages.scrollTop = messages.scrollHeight
  }

  observeMessages() {
    const observer = new MutationObserver(() => {
      this.scrollToBottom()
    })

    observer.observe(this.messagesTarget, {
      childList: true,
      subtree: true
    })
  }
}
