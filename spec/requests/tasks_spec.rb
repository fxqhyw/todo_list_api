require 'rails_helper'

RSpec.describe 'Tasks management', type: :request do
  let(:user) { create(:user) }
  let(:task) { create(:task) }
  let(:auth_headers) { user.create_new_auth_token }

  describe 'GET /api/v1/projects/:project_id/tasks' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        get api_v1_project_tasks_path(task.project)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
    end
  end

  describe 'POST /api/v1/projects/:project_id/tasks' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        post api_v1_project_tasks_path(task.project)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
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
