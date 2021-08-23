require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:role) }
  end

  context 'relationships' do
    it { is_expected.to have_many :user_tokens }
    it { is_expected.to have_and_belong_to_many :addresses }
  end
end
