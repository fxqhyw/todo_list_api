module Api::V1
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource :task, only: %i[index create]
    load_and_authorize_resource through: :task, only: %i[index create]
    load_and_authorize_resource only: :destroy

    respond_to :json

    resource_description do
      short 'Manage of comments which belongs to current user'
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable entity'
      formats ['json']
    end

    api :GET, '/v1/tasks/:task_id/comments', 'Returns list of task comment by task_id'
    param :task_id, :number, required: true
    def index
      respond_with @comments
    end

    api :POST, '/v1/tasks/:task_id/comments', 'Creates new comment by task_id and return it'
    param :task_id, :number, required: true
    param :data, Hash, required: true do
      param :attributes, Hash, required: true do
        param :body, String, required: true
        param :image, String, allow_blank: true
      end
    end
    def create
      return respond_with @comment, status: :created if @comment.save

      render json: @comment.errors, status: :unprocessable_entity
    end

    api :DELETE, '/v1/comments/:id', 'Destroy current user comment by id'
    param :id, :number, required: true
    def destroy
      @comment.destroy
      head :no_content
    end

    private

    def comment_params
      params.require(:data).require(:attributes).permit(:body, :image)
    end
  end
end
