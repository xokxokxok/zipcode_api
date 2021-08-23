require 'rails_helper'

RSpec.describe UserAddress, type: :model do
  context 'relationships' do
    it { is_expected.to belong_to :address }
    it { is_expected.to belong_to :user }
  end
end
