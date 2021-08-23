require 'rails_helper'

RSpec.describe UserTokenCreator do
  fixtures :users

  let(:user) { users.first }
  let(:password) { 'admin123456' }

  describe '.call' do
    it 'instanciates the class and calls method #call' do
      call = double(:call)
      expect(call).to receive(:call)
      expect(described_class).to receive(:new).with('email', 'password').and_return(call)

      described_class.call('email', 'password')
    end
  end

  describe '#call' do
    context 'when email and password are valid' do
      let!(:now) { DateTime.now }
      before { expect(DateTime).to receive(:now).and_return(now) }

      it 'returns a new user token' do
        user_token = described_class.new(user.email, password).call
        expect(user_token).to be_persisted
        expect(user_token).to be_an_is_a(UserToken)
        expect(user_token.id).to match(/[A-z0-9\-]+/)
        expect(user_token.expires_at).to eq(now + ENV['API_TOKEN_DURATION_MINUTES'].to_i.minutes)
      end
    end

    context 'when email is invalid' do
      it 'returns a new user token with errors when user does not exists' do
        user_token = described_class.new('no_email', password).call
        expect(user_token).to be_an_is_a(UserToken)
        expect(user_token.errors.messages[:user]).to eq(['not found'])
      end
    end

    context 'when password is invalid' do
      it 'returns a new user token with errors when user does not exists' do
        user_token = described_class.new(user.email, 'no-password').call
        expect(user_token).to be_an_is_a(UserToken)
        expect(user_token.errors.messages[:password]).to eq(['invalid'])
      end
    end
  end
end
