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
    let(:valid_params) do
      {
        "data": {
          "type": "string",
          "attributes": {
            "name": 'valid name',
            "deadline": Date.tomorrow
          }
        }
      }
    end
    let(:invalid_params) do
      {
        "data": {
          "type": "string",
          "attributes": {
            "name": '',
            "deadline": 'someday'
          }
        }
      }
    end

    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        patch api_v1_task_path(task), params: valid_params
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      context 'valid params' do
        before { patch api_v1_task_path(task), headers: auth_headers, params: valid_params }

        it 'updates tasks fields in the database' do
          task.reload
          expect(task.name).to eq('valid name')
          expect(task.deadline).to eq(Date.tomorrow)
        end

        it 'returns the updated task' do
          expect(response).to have_http_status 201
          expect(response).to match_response_schema('tasks/task')
        end
      end

      context 'invalid params' do
        before { patch api_v1_task_path(task), headers: auth_headers, params: invalid_params }

        it 'does not update the task in the database' do
          task.reload
          expect(task.deadline).not_to eq('someday')
        end

        it 'returns http status 422 :unprocessable_entity' do
          expect(response).to have_http_status 422
        end
      end
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
      it 'destroys the task in the database' do
        task
        expect {
          delete api_v1_task_path(task), headers: auth_headers
        }.to change(Task, :count).from(1).to(0)
      end

      it 'returns http status 204 :no_content' do
        delete api_v1_task_path(task), headers: auth_headers
        expect(response).to have_http_status 204
      end
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
      before { patch complete_api_v1_task_path(task), headers: auth_headers }

      it 'updates task done field to true' do
        expect(task.done).to be_falsy
        task.reload
        expect(task.done).to be_truthy
      end

      it 'returns the updated task' do
        expect(response).to have_http_status 201
        expect(response).to match_response_schema('tasks/task')
      end
    end
  end

  describe 'PATCH /api/v1/tasks/:id/position' do
    let(:params) do
      {
        "data": {
          "type": "string",
          "attributes": {
            "position": 3
          }
        }
      }
    end
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        patch position_api_v1_task_path(task), params: params
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      before { patch position_api_v1_task_path(task), headers: auth_headers, params: params }
      it 'updates task position field' do
        task.reload
        expect(task.position).to eq(3)
      end

      it 'returns the updated task' do
        expect(response).to have_http_status 201
        expect(response).to match_response_schema('tasks/task')
      end
    end
  end
end
