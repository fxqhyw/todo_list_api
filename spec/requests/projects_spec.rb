require 'rails_helper'

RSpec.describe 'Projects management', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }
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

  describe 'GET /api/v1/projects' do
    before { create_list(:project, 3, user: user) }

    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        get api_v1_projects_path
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      it 'returns an array of user projects' do
        get api_v1_projects_path, headers: auth_headers
        expect(response).to have_http_status 200
        expect(response).to match_response_schema('projects/projects')
      end
    end
  end

  describe 'POST /api/v1/projects' do
    context 'unauthorized user' do
      it 'returns http status 401 unauthorized' do
        post api_v1_projects_path
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      context 'valid params' do
        it 'creates new project in the database' do
          expect {
            post api_v1_projects_path, params: valid_params, headers: auth_headers
          }.to change(Project, :count).from(0).to(1)
        end

        it 'returns the created project' do
          post api_v1_projects_path, params: valid_params, headers: auth_headers
          expect(response).to have_http_status 201
          expect(response).to match_response_schema('projects/project')
        end
      end

      context 'invalid params' do
        it 'does not create new project in the database' do
          expect {
            post api_v1_projects_path, params: invalid_params, headers: auth_headers
          }.not_to change(Project, :count)
        end

        it 'returns http status 422 :unprocessable_entity' do
          post api_v1_projects_path, params: invalid_params, headers: auth_headers
          expect(response).to have_http_status 422
        end
      end
    end
  end

  describe 'GET /api/v1/projects/:id' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        get api_v1_project_path(project)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      it 'returns a user project by id' do
        get api_v1_project_path(project), headers: auth_headers
        expect(response).to have_http_status 200
        expect(response).to match_response_schema('projects/project')
      end
    end
  end

  describe 'PATCH /api/v1/projects/:id' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        patch api_v1_project_path(project), params: valid_params
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      context 'valid params' do
        before { patch api_v1_project_path(project), params: valid_params, headers: auth_headers }

        it 'updates project fields in the database' do
          project.reload
          expect(project.name).to eq('valid name')
        end

        it 'returns the updated project' do
          expect(response).to have_http_status 201
          expect(response).to match_response_schema('projects/project')
        end
      end

      context 'invalid params' do
        before { patch api_v1_project_path(project), params: invalid_params, headers: auth_headers }

        it 'does not update project fields in the database' do
          project.reload
          expect(project.name).not_to eq('valid name')
        end

        it 'returns http status 422 :unprocessable_entity' do
          expect(response).to have_http_status 422
        end
      end
    end
  end

  describe 'DELETE /api/v1/projects/:id' do
    context 'unauthorized user' do
      it 'returns http status 401 :unauthorized' do
        delete api_v1_project_path(project)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      it 'destroys project in the database' do
        project
        expect {
          delete api_v1_project_path(project), headers: auth_headers
        }.to change(Project, :count).from(1).to(0)
      end

      it 'returns http status 204 :no_content' do
        project
        delete api_v1_project_path(project), headers: auth_headers
        expect(response).to have_http_status 204
      end
    end
  end
end
