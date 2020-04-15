class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :verify]
  skip_before_action :authorize, only: [:new, :create, :verify]
  before_action :check_if_already_activated, only: [:verify]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: t('.signed_up') }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: t('.updated') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: t('.destroyed') }
      format.json { head :no_content }
    end
  end

  def verify
    if @user.activate(params[:token])
      redirect_to root_path, notice: t('.activated', name: @user.name)
    else
      redirect_to root_path, notice: t('cannot_activate')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by_id(params[:id])
      if @user.blank?
        redirect_to root_path, notice: t('.not_found')
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:avatar, :name, :email, :password, :password_confirmation)
    end

    def check_if_already_activated
      if @user.active?
        redirect_to root_path, notice: t('.already_active')
      end
    end
end
