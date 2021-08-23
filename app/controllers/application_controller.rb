class ApplicationController < ActionController::Base

  prepend_before_action :initialize_query_params
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(user)
    if user.role.admin?
      admin_users_path
    elsif user.role.consumer?
      admin_show_user_path(id: user.id)
    end
  end

  def after_sign_out_path_for(user)
    new_user_session_path
  end

  def after_sign_up_path_for(user)
    new_user_session_path
  end

  def page
    params.try(:[], :page) || 1
  end

  def per_page
    params.try(:[], :per_page) || 10
  end

  def default_flash_success_message(action = :default)
    { success: I18n.t("controllers.default.flash.#{action}.success") }
  end

  def default_flash_error_message(action)
    { error: I18n.t("controllers.default.flash.#{action}.error") }
  end

  def initialize_query_params
    params[:q] = {} if params.try(:[], :q).blank?
  end


  protected


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:name, :email, :password, :password_confirmation)
    end
  end
end
