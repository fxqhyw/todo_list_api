require 'rails_helper'

RSpec.describe 'Tasks management', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:auth_headers) { user.create_new_auth_token }

  describe 'GET /api/v1/projects/:project_id/tasks' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        get api_v1_project_tasks_path(project)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      it 'returns an array of project tasks' do
        create_list(:task, 3, project: project)
        get api_v1_project_tasks_path(project), headers: auth_headers
        expect(response).to have_http_status 200
        expect(response).to match_response_schema('tasks/tasks')
      end
    end
  end

  describe 'POST /api/v1/projects/:project_id/tasks' do
    let(:valid_params) do
      {
        "data": {
          "type": "string",
          "attributes": {
            "name": 'valid name'
          }
        }
      }
    end
    let(:invalid_params) do
      {
        "data": {
          "type": "string",
          "attributes": {
            "name": ''
          }
        }
      }
    end
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        post api_v1_project_tasks_path(project), params: valid_params
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      context 'valid params' do
        it 'creates new task in the database' do
          expect {
            post api_v1_project_tasks_path(project), headers: auth_headers, params: valid_params
          }.to change(Task, :count).from(0).to(1)
        end

        it 'returns the created task' do
          post api_v1_project_tasks_path(project), headers: auth_headers, params: valid_params
          expect(response).to have_http_status 201
          expect(response).to match_response_schema('tasks/task')
        end
      end

      context 'invalid params' do
        it 'does not create new task in the database' do
          expect {
            post api_v1_project_tasks_path(project), headers: auth_headers, params: invalid_params
          }.not_to change(Task, :count)
        end

        it 'returns http status 422 :unprocessable_entity' do
          post api_v1_project_tasks_path(project), headers: auth_headers, params: invalid_params
          expect(response).to have_http_status 422
        end
      end
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        get api_v1_task_path(task)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      it 'returns the project task by id' do
        get api_v1_task_path(task), headers: auth_headers
        expect(response).to have_http_status 200
        expect(response).to match_response_schema('tasks/task')
      end
    end
  end

  describe 'PATCH /api/v1/tasks/:id' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        patch api_v1_task_path(task)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
    end
  end

  describe 'DELETE /api/v1/tasks/:id' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        delete api_v1_task_path(task)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
    end
  end

  describe 'PATCH /api/v1/tasks/:id/complete' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        patch complete_api_v1_task_path(task)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
    end
  end

  describe 'PATCH /api/v1/tasks/:id/position' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        patch position_api_v1_task_path(task)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
    end
  end
end
