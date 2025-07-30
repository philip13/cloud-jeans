import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-list"
export default class extends Controller {
  static targets = ["item"]

  select(event) {
    this.itemTargets.forEach(el => {
      el.classList.remove("list-group-item-success")
      el.classList.add("list-group-item-light")
    })
    const clicked = event.currentTarget
    clicked.classList.remove("list-group-item-light")
    clicked.classList.add("list-group-item-success")
  }
}
