module Api
  module V1
    class ApplicationController < ::ActionController::API
      class NotFoundTokenError < ActionController::InvalidAuthenticityToken; end
      class ExpiredTokenError < ActionController::InvalidAuthenticityToken; end

      attr_reader :current_user, :current_ability

      prepend_before_action :auth_user

      rescue_from ActiveRecord::RecordNotFound do |e|
        render status: :not_found, json: { error: e&.message&.as_json }
      end

      rescue_from ApplicationController::NotFoundTokenError do |e|
        render status: :unauthorized, json: { error: e&.message&.as_json }
      end

      rescue_from ApplicationController::ExpiredTokenError do |e|
        render status: :unauthorized, json: { error: e&.message&.as_json }
      end

    private

      def token
        request.headers['token'] || request.headers['Token']
      end

      def auth_user
        @user_token ||= UserToken.find_by(id: token)
        raise ApplicationController::NotFoundTokenError, "Invalid token" if @user_token.blank?
        raise ApplicationController::ExpiredTokenError, "Expired token" unless @user_token.expired?

        @current_user ||= UserToken.find_by(id: token).try(:user)
        @current_ability ||= Ability.new(current_user)
      rescue
        render status: :unauthorized
      end

      def page
        params.try(:[], :page) || 1
      end

      def per_page
        params.try(:[], :per_page) || 10
      end
    end
  end
end
