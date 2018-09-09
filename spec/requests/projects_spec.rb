require 'rails_helper'

RSpec.describe 'Projects management', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }

  describe 'GET /projects' do
    before { create_list(:project, 3, user: user) }

    context 'unauthorized user' do
      it 'returns http status 401 unauthorized' do
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

  describe 'GET /projects/:id' do
    context 'unauthorized user' do
      it 'returns http status 401 unauthorized' do
        get api_v1_project_path(project)
        expect(response).to have_http_status 401
      end
    end

    context 'authorized user' do
      it 'returns a user project by id' do
        get api_v1_project_path(project), headers: auth_headers
        expect(response.status).to eq 200
        expect(response).to match_response_schema('projects/project')
      end
    end
  end
end
