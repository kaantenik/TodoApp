json.extract! task, :id, :title, :description, :due_date, :priority, :completed, :category_id, :created_at, :updated_at
json.url task_url(task, format: :json)
