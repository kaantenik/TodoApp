import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import { Turkish } from "flatpickr/dist/l10n/tr.js"

export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      locale: Turkish,
      altInput: true,
      altFormat: "d F Y",
      dateFormat: "Y-m-d",
      allowInput: true,
      clickOpens: true,
      disableMobile: false,
      enableTime: false,
      time_24hr: true,
      minDate: "today",
      static: true
    })
  }
}
