module Api::V1
  class ProjectsController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource

    respond_to :json

    def index
      respond_with @projects
    end

    def show
      respond_with @project
    end
  end
end
