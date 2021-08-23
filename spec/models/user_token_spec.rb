require 'rails_helper'

RSpec.describe UserToken, type: :model do
  context 'relationships' do
    it { is_expected.to belong_to :user }
  end
end
