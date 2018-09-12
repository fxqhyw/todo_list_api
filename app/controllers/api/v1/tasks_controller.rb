module Api::V1
  class TasksController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource :project, only: %i[index create]
    load_and_authorize_resource through: :project, only: %i[index create]
    load_and_authorize_resource except: %i[index create]

    respond_to :json

    def index
      respond_with @tasks
    end

    def create
      return respond_with @task, status: :created if @task.save

      render json: @task.errors, status: :unprocessable_entity
    end

    def show
      respond_with @task
    end

    def update
      return respond_with @task, status: :created if @task.update(task_params_with_deadline)

      render json: @task.errors, status: :unprocessable_entity
    end

    def destroy
      @task.destroy
      head :no_content
    end

    def complete
      @task.update(done: true)
      respond_with @task, status: :created
    end

    def position
      @task.insert_at(position_params[:position].to_i)
      respond_with @task, status: :created
    end

    private

    def task_params
      params.require(:data).require(:attributes).permit(:name)
    end

    def task_params_with_deadline
      params.require(:data).require(:attributes).permit(:name, :deadline)
    end

    def position_params
      params.require(:data).require(:attributes).permit(:position)
    end
  end
end
