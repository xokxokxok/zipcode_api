module Admin
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!
    prepend_before_action :set_globals

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

    def current_ability
      @current_ability ||= Ability.new(current_user)
    end

    def set_globals
      @current_user = current_user
    end
  end
end
