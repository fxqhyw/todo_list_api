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
    end

    def destroy
    end

    def complete
    end

    def position
    end

    private

    def task_params
      params.require(:data).require(:attributes).permit(:name)
    end
  end
end
