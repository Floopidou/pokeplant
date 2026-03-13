import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileInput", "previewImg", "placeholder", "submitBtn"]

  pick() {
    this.fileInputTarget.click()
  }

  showPreview() {
    const file = this.fileInputTarget.files[0]
    if (!file) return
    this.previewImgTarget.src = URL.createObjectURL(file)
    this.previewImgTarget.style.display = "block"
    this.placeholderTarget.style.display = "none"
    this.submitBtnTarget.disabled = false
  }
}
