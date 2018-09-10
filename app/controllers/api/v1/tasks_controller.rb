module Api::V1
  class TasksController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource

    respond_to :json

    def index
    end

    def create
    end

    def show
    end

    def update
    end

    def destroy
    end

    def complete
    end

    def position
    end
  end
end
