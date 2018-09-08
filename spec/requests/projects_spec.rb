require 'rails_helper'

RSpec.describe 'Projects management', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  it 'returns a user project by id' do
    auth_headers = user.create_new_auth_token
    get api_v1_project_path(project), headers: auth_headers
    expect(response.status).to eq 200
    expect(response).to match_response_schema('project')
  end
end
