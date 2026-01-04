import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["inner"]

  toggle(event) {
    // prevent Space from scrolling
    if (event.target.closest("button, a, input, textarea, select, form, label")) return
    if (event?.type === "keydown") event.preventDefault()
    this.innerTarget.classList.toggle("is-flipped")
  }
}

