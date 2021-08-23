module Admin
  class UsersController < Admin::ApplicationController
    load_and_authorize_resource

    def show
      respond_to do |format|
        format.html { render :show }
      end
    end

    def index
      @q = User.accessible_by(current_ability, :index).ransack(params[:q])
      @users = @q.result(distinct: true).page(page).per(per_page)

      respond_to do |format|
        format.html { render :index }
      end
    end

    def edit
      respond_to do |format|
        format.html { render :edit }
      end
    end

    def update
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to admin_users_path, flash: default_flash_success_message(:update) }
        else
          format.html { render :edit, flash: default_flash_error_message(:update) }
        end
      end
    end

    private

    def user_params
      p = params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation
      )
      p = p.except(:password, :password_confirmation) if p[:password].blank?
      return p
    end
  end
end
