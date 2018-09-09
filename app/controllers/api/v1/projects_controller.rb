module Api::V1
  class ProjectsController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource

    respond_to :json

    def index
      respond_with @projects
    end

    def create
      if @project.save
        respond_with @project, status: :created
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    def show
      respond_with @project
    end

    private

    def project_params
      params.require(:data).permit(:name)
    end
  end
end
