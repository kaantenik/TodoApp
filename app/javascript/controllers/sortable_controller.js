import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      ghostClass: "sortable-ghost",
      onEnd: this.end.bind(this)
    })
  }

  end(event) {
    const taskId = event.item.dataset.taskId
    const newIndex = event.newIndex
    const url = `/tasks/${taskId}/reorder`
    
    fetch(url, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ position: newIndex })
    })
  }
} 