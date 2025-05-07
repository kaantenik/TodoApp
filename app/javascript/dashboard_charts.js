document.addEventListener("DOMContentLoaded", () => {
    const statusCtx = document.getElementById("statusChart");
    const priorityCtx = document.getElementById("priorityChart");
  
    if (statusCtx && priorityCtx && window.Chart) {
      const statusData = JSON.parse(statusCtx.dataset.status);
      const priorityData = JSON.parse(priorityCtx.dataset.priority);
  
      new Chart(statusCtx, {
        type: "doughnut",
        data: {
          labels: ["Tamamlanan", "Bekleyen"],
          datasets: [{
            label: "Görev Durumu",
            data: [statusData.completed, statusData.pending],
            backgroundColor: ["#4caf50", "#f44336"]
          }]
        }
      });
  
      new Chart(priorityCtx, {
        type: "bar",
        data: {
          labels: ["Düşük", "Orta", "Yüksek"],
          datasets: [{
            label: "Öncelik",
            data: [priorityData.low, priorityData.medium, priorityData.high],
            backgroundColor: ["#2196f3", "#ffc107", "#e91e63"]
          }]
        }
      });
    }
  });
  