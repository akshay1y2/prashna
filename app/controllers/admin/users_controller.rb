#FIXME_AB: you should define like nesting
# module Admin
#   class UsersController
#   end
# end

#FIXME_AB: Also all admin controller should inherit from AdminBaseController
class Admin::UsersController < ApplicationController

  #FIXME_AB: admin section will have a seperate admin layout, specify in admin base controler

  #FIXME_AB: move this to admin base controller
  before_action :authorize_admin
  before_action :set_user, only: [:show, :destroy]
  #FIXME_AB: admin should be able to edit/update other users. including user's admin role

  def index
    #FIXME_AB: paginated list
    @users = User.all
  end

  def destroy
    #FIXME_AB: logged in user should not be able to delete himself. Check this in before action
    #FIXME_AB: link to destroy should also not come in view for myself
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

  #FIXME_AB: this should go in admin base controller
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
