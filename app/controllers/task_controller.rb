class TaskController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def create
      user = User.find(task_params[:users_id]) # Assuming user_id is present in task_params
      task = user.task.build(task_params.except(:users_id))

      if task.save
        render json: task, status: :created
      else
        render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      task = Task.find(params[:id])

      if task.update(task_params)
        render json: task, status: :ok
      else
        render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def tasks_by_status
      status = params[:status]
      tasks = Task.where(status: status)

      if tasks.any?
        render json: tasks, status: :ok
      else
        render json: { error: "No tasks found with status #{status}" }, status: :not_found
      end
    end

    def index
      tasks = Task.all
      render json: tasks, status: :ok
    end

    def destroy
      task = Task.find_by(id: params[:id])

      if task
        task.destroy
        head :no_content
      else
        render json: { error: "Task with id #{params[:id]} not found" }, status: :not_found
      end
    end

    private

    def render_not_found_response
      render json: { error: "Task not found" }, status: :not_found
    end

    def render_unprocessable_entity_response(exception)
      render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end

    def task_params
      params.require(:task).permit(:title, :description, :status , :users_id)
    end
  end
