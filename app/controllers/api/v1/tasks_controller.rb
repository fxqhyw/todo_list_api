module Api::V1
  class TasksController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource :project, only: %i[index create]
    load_and_authorize_resource through: :project, only: %i[index create]
    load_and_authorize_resource except: %i[index create]

    respond_to :json

    resource_description do
      short 'Manage of tasks which belongs to current user'
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable entity'
      formats ['json']
    end

    api :GET, '/v1/projects/:project_id/tasks', 'Returns list of project tasks by project_id'
    param :project_id, :number, required: true
    def index
      respond_with @tasks
    end

    api :POST, '/v1/projects/:project_id/tasks', 'Creates new project task and returns it'
    param :project_id, :number, required: true
    param :data, Hash, required: true do
      param :attributes, Hash, required: true do
        param :name, String, required: true
      end
    end
    def create
      return respond_with @task, status: :created if @task.save

      render json: @task.errors, status: :unprocessable_entity
    end

    api :GET, '/v1/tasks/:id', 'Returns current user task by id'
    param :id, :number, required: true
    def show
      respond_with @task
    end

    api :PATCH, '/v1/tasks/:id', 'Updates task name or deadline by id'
    param :id, :number, required: true
    param :data, Hash, required: true do
      param :attributes, Hash, required: true do
        param :name, String
        param :deadline, String
      end
    end
    def update
      return respond_with @task, status: :created if @task.update(task_params_with_deadline)

      render json: @task.errors, status: :unprocessable_entity
    end

    api :DELETE, '/v1/tasks/:id', 'Destroy current user task with comments which belongs to it'
    param :id, :number, required: true
    example 'Returns nothing'
    def destroy
      @task.destroy
      head :no_content
    end

    api :PATCH, '/v1/tasks/:id/complete', 'Updates task done field to true by id'
    param :id, :number, required: true
    def complete
      @task.update(done: true)
      respond_with @task, status: :created
    end

    api :PATCH, '/v1/tasks/:id/complete', 'Updates task position field by id'
    param :id, :number, required: true
    param :data, Hash, required: true do
      param :attributes, Hash, required: true do
        param :position, :number, required: true
      end
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
