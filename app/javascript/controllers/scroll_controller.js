import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll"
export default class extends Controller {
  static targets = ["content"]

  scrollToBottom() {
    this.contentTarget.scrollTop = this.contentTarget.scrollHeight
  }
}
