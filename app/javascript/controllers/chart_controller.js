import { Controller } from "@hotwired/stimulus";
import Chart from "dashboard_charts.js";

export default class extends Controller {
  connect() {
    const ctx = this.element.getContext("2d");

    const data = JSON.parse(this.element.dataset.chartData);

    new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: data.labels,
        datasets: [{
          label: "Görev Durumu",
          data: data.values,
          backgroundColor: ["#28a745", "#ffc107"],
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: "bottom"
          }
        }
      }
    });
  }
}
