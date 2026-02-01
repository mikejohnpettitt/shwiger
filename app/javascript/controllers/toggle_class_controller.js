import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static classes = ["active"];

  toggle(event) {
    event.currentTarget.classList.toggle(this.activeClass);
  }
}
