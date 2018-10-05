require 'rails_helper'

RSpec.describe 'Comments management', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:comment) { create(:comment, task: task) }
  let(:auth_headers) { user.create_new_auth_token }

  describe 'GET /api/v1/tasks/:task_id/comments' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized', :show_in_doc do
        get api_v1_task_comments_path(task)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      it 'returns an array of task comments', :show_in_doc do
        create_list(:comment, 3, task: task)
        get api_v1_task_comments_path(task), headers: auth_headers
        expect(response).to have_http_status 200
        expect(response).to match_response_schema('comments/comments')
      end
    end
  end

  describe 'POST /api/v1/tasks/:task_id/comments' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized', :show_in_doc do
        post api_v1_task_comments_path(task)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      let(:valid_params) do
        {
          "data": {
            "type": "string",
            "attributes": {
              "body": "Valid comment sentence",
              "image": nil
            }
          }
        }
      end
      let(:invalid_params) do
        {
          "data": {
            "type": "string",
            "attributes": {
              "body": 'short'
            }
          }
        }
      end
      context 'valid params' do
        it 'creates new comment in the database' do
          expect {
            post api_v1_task_comments_path(task), headers: auth_headers, params: valid_params
          }.to change(Comment, :count).from(0).to(1)
        end

        it 'returns the created comment', :show_in_doc do
          post api_v1_task_comments_path(task), headers: auth_headers, params: valid_params
          expect(response).to have_http_status 201
          expect(response).to match_response_schema('comments/comment')
        end
      end

      context 'invalid_params' do
        it 'does not create new comment in the database' do
          expect {
            post api_v1_task_comments_path(task), headers: auth_headers, params: invalid_params
          }.not_to change(Comment, :count)
        end

        it 'returns http status 422 :unprocessable_entity', :show_in_doc do
          post api_v1_task_comments_path(task), headers: auth_headers, params: invalid_params
          expect(response).to have_http_status 422
        end
      end
    end
  end

  describe 'DELETE /api/v1/comments/:id' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized', :show_in_doc do
        delete api_v1_comment_path(comment)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      it 'destroys the task in the database' do
        comment
        expect {
          delete api_v1_comment_path(comment), headers: auth_headers
        }.to change(Comment, :count).from(1).to(0)
      end

      it 'returns http status 204 :no_content', :show_in_doc do
        delete api_v1_comment_path(comment), headers: auth_headers
        expect(response).to have_http_status 204
      end
    end
  end
end
