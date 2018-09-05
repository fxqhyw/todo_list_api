require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { is_expected.to have_many :projects }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
  end
end
