module Api::V1
  class ProjectsController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource

    respond_to :json

    resource_description do
      short 'Manage of projects which belongs to current user'
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable entity'
      formats ['json']
    end

    def_param_group :project do
      param :data, Hash, required: true do
        param :attributes, Hash, required: true do
          param :name, String, required: true
        end
      end
    end

    api :GET, '/v1/projects', 'Returns all current user projects'
    def index
      respond_with @projects
    end

    api :POST, '/v1/projects', 'Creates a new user project and returns it'
    param_group :project
    def create
      return respond_with @project, status: :created if @project.save

      render json: @project.errors, status: :unprocessable_entity
    end

    api :GET, '/v1/projects/:id', 'Returns current user project by id'
    param :id, :number, required: true
    def show
      respond_with @project
    end

    api :PATCH, '/v1/projects/:id', 'Updates current user project name by id'
    param_group :project
    def update
      return respond_with @project, status: :created if @project.update(project_params)

      render json: @project.errors, status: :unprocessable_entity
    end

    api :DELETE, '/v1/projects/:id', 'Destroy current user project with tasks which belongs to it'
    param :id, :number, required: true
    def destroy
      @project.destroy
      head :no_content
    end

    private

    def project_params
      params.require(:data).require(:attributes).permit(:name)
    end
  end
end
