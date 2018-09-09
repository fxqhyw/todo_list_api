module Api::V1
  class ProjectsController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource

    respond_to :json

    def index
      respond_with @projects
    end

    def create
      return respond_with @project, status: :created if @project.save
      render json: @project.errors, status: :unprocessable_entity
    end

    def show
      respond_with @project
    end

    def update
      return respond_with @project, status: :created if @project.update(project_params)
      render json: @project.errors, status: :unprocessable_entity
    end

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
