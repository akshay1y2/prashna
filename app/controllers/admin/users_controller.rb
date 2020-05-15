module Admin
  class UsersController < BaseController
    before_action :set_user, :check_if_updating_self, only: [:edit, :update, :destroy]

    def index
      @users = User.all.page(params[:page])
    end

    def edit
      @topics = @user.topic_names.join(', ')
    end

    def update
      @user.set_topics params[:user][:topics]
      @user.admin = params[:user][:admin].present?
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to admin_users_path, notice: 'User Successfully Updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      respond_to do |format|
        if @user.destroy
          format.html { redirect_to admin_users_url, notice: t('.destroyed') }
          format.json { head :no_content }
        else
          format.html { redirect_to admin_users_path(@admin), notice: t('.not_destroyed') }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    private def set_user
      unless @user = User.find_by_id(params[:id])
        redirect_to admin_users_path, notice: 'User not found!'
      end
    end

    private def check_if_updating_self
      if current_user == @user
        redirect_to admin_users_path, notice: 'You are trying to update this account!'
      end
    end
    private def user_params
      params.require(:user).permit(:avatar, :name, :email, :password, :password_confirmation)
    end
  end
end
