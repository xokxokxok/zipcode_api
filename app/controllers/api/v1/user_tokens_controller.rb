module Api
  module V1
    class UserTokensController < Api::V1::ApplicationController
      def create
        user_token = UserTokenCreator.call(user_token_params[:email], user_token_params[:password])

        if user_token.persisted?
          render json: { token: user_token.id, expires_at: user_token.expires_at }
        else
          render state: 401, json: { errors: user_token.errors.messages.as_json }
        end
      end

    private

      def auth_user
        true
      end

      def user_token_params
        @user_token_params ||= params.permit(:email, :password)
      end
    end
  end
end
