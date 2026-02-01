import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["ids"];

  connect() {
    this.selected = new Set();
  }

  toggle(event) {
    const btn = event.currentTarget;
    const id = btn.dataset.selectionIdValue;

    if (this.selected.has(id)) {
      this.selected.delete(id);
      btn.classList.remove("is-active");
    } else {
      this.selected.add(id);
      btn.classList.add("is-active");
    }

    // store as comma-separated (or JSON) for submission
    this.idsTarget.value = Array.from(this.selected).join(",");
  }
}
