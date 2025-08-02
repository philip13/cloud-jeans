import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-list"
export default class extends Controller {
  static targets = ["item"]

  select(event) {
    this.itemTargets.forEach(el => {
      el.classList.remove("success")
    })

    const clicked = event.currentTarget
    clicked.classList.add("success")
  }
}
