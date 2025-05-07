class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy reorder ]

  def complete
    @task = Task.find(params[:id])
    @task.complete!
    redirect_to tasks_path, notice: "Görev tamamlandı!"
  end

  def completed
    @completed_tasks = Task.completed

    # Filtreleme
    if params[:category_id].present?
      @completed_tasks = @completed_tasks.where(category_id: params[:category_id])
    end

    if params[:priority].present?
      @completed_tasks = @completed_tasks.where(priority: params[:priority])
    end

    if params[:search].present?
      @completed_tasks = @completed_tasks.where("title LIKE ? OR description LIKE ?",
                           "%#{params[:search]}%",
                           "%#{params[:search]}%")
    end

    # İstatistikler
    @completed_this_month = Task.completed.where(updated_at: Time.current.beginning_of_month..Time.current.end_of_month).count
    @completed_this_week = Task.completed.where(updated_at: Time.current.beginning_of_week..Time.current.end_of_week).count
    @completed_today = Task.completed.where(updated_at: Time.current.beginning_of_day..Time.current.end_of_day).count

    # Filtreleme seçenekleri için
    @categories = Category.all
  end

  def dashboard
    @total_tasks = Task.count
    @completed_tasks = Task.completed.count
    @pending_tasks = Task.pending.count

    @chart_data = {
      labels: ["Tamamlandı", "Bekliyor"],
      values: [@completed_tasks, @pending_tasks]
    }
  end

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all

    # Filtreleme
    if params[:category_id].present?
      @tasks = @tasks.where(category_id: params[:category_id])
    end

    if params[:priority].present?
      @tasks = @tasks.where(priority: params[:priority])
    end

    if params[:status].present?
      case params[:status]
      when 'completed'
        @tasks = @tasks.completed
      when 'pending'
        @tasks = @tasks.pending
      when 'today'
        @tasks = @tasks.due_today
      when 'overdue'
        @tasks = @tasks.overdue
      end
    end

    if params[:search].present?
      @tasks = @tasks.where("title LIKE ? OR description LIKE ?",
                           "%#{params[:search]}%",
                           "%#{params[:search]}%")
    end

    # Sıralama
    @tasks = @tasks.order(due_date: :asc)

    # İstatistikler - Filtrelenmiş görevler üzerinden hesaplanıyor
    @total_tasks = @tasks.count
    @completed_tasks = @tasks.completed.count
    @pending_tasks = @tasks.pending.count
    @today_tasks = @tasks.due_today.count

    @priority_counts = {
      low: @tasks.where(priority: "low").count,
      medium: @tasks.where(priority: "medium").count,
      high: @tasks.where(priority: "high").count
    }

    # Filtreleme seçenekleri için
    @categories = Category.all
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_path, status: :see_other, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def reorder
    @task.insert_at(params[:position].to_i + 1)
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :due_date, :priority, :completed, :category_id)
    end
end
