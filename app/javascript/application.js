// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"
import flatpickr from "flatpickr"
import "flatpickr/dist/flatpickr.css"
import { Turkish } from "flatpickr/dist/l10n/tr.js"

flatpickr.localize(Turkish)
