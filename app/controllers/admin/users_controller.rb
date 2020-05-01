class Admin::UsersController < ApplicationController
  before_action :authorize_admin
  before_action :set_user, only: [:show, :destroy]

  def index
    @users = User.all
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

  private def authorize_admin
    unless current_user.admin
      redirect_to root_path, notice: t('.access_denied')
    end
  end

  private def set_user
    @user = User.find_by_id(params[:id])
    if @user.blank?
      redirect_to admin_users_path, notice: t('.not_found')
    end
  end
end
