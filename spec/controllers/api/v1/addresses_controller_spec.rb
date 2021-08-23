require 'rails_helper'

RSpec.describe Api::V1::AddressesController, type: :controller do
  fixtures :users

  let(:zip_code) { '04209003' }
  let!(:user) { users.first }
  let!(:user_token) { UserToken.create(user_id: user.id, expires_at: DateTime.now + 1.hour).id }

  before do
    request.headers.merge!(token: user_token)
    Rails.cache.delete("#{zip_code}/finder")
  end

  describe 'GET /index' do
    it 'returns address json' do
      expect(user.reload.addresses.where(zip_code: zip_code).present?).to be_falsey

      get :show, params: { zip_code: zip_code }

      json = JSON.parse(response.body)

      expect(json['zip_code']).to eq zip_code

      expect(user.reload.addresses.where(zip_code: zip_code).present?).to be_truthy
    end

    context 'when user does not exist' do
      before do
        request.headers.merge!(token: '12345678')
      end

      it 'returns error json' do
        get :show, params: { zip_code: zip_code }

        json = JSON.parse(response.body)

        expect(json['error']).to eq 'Invalid token'
      end
    end

    context 'when token is invalid' do
      before do
        UserToken.find(user_token).update(expires_at: DateTime.now - 1.hour)
      end

      it 'returns error json' do
        get :show, params: { zip_code: zip_code }

        json = JSON.parse(response.body)

        expect(json['error']).to eq 'Expired token'
      end
    end

    context 'when zip code is invalid' do
      it 'returns error json' do
        get :show, params: { zip_code: '12345678' }

        json = JSON.parse(response.body)

        expect(json['error']).to eq 'Zip code not found'
      end
    end
  end
end
