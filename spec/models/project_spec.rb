require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
  end
end
