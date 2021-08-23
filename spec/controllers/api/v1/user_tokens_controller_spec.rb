require 'rails_helper'

RSpec.describe Api::V1::UserTokensController, type: :controller do
  fixtures :users

  let!(:user) { users.first }
  let!(:password) { 'admin123456' }

  describe 'GET /create' do
    it 'returns token json' do
      post :create, params: { email: user.email, password: password }

      json = JSON.parse(response.body)

      expect(json['token']).to_not be_nil
    end

    context 'when user does not exists' do
      it 'returns error json' do
        post :create, params: { email: 'no_user', password: password }

        json = JSON.parse(response.body)

        expect(json['errors']['user']).to eq(['not found'])
      end
    end

    context 'when password is invalid' do
      it 'returns error json' do
        post :create, params: { email: user.email, password: 'invalid' }

        json = JSON.parse(response.body)

        expect(json['errors']['password']).to eq(['invalid'])
      end
    end
  end
end
