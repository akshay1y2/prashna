class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy, :verify]
  skip_before_action :authorize, only: [:new, :create, :verify]
  before_action :check_if_already_activated, only: [:verify]
  after_action :mark_notifications_as_viewed, only: [:notifications]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @topics = current_user.topic_names.join(', ')
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_path, notice: t('.signed_up') }
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
    current_user.set_topics params[:user][:topics]
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to current_user, notice: t('.updated') }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :edit }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
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
      redirect_to login_path, notice: t('.activated', name: @user.name)
    else
      redirect_to login_path, notice: t('cannot_activate')
    end
  end

  def notifications
    @notifications = current_user.notifications.order(:viewed, updated_at: 'desc').page(params[:page])
    render 'notifications/index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by_id(params[:id])
      if @user.blank?
        redirect_to login_path, notice: t('.not_found')
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:avatar, :name, :email, :password, :password_confirmation)
    end

    def check_if_already_activated
      if @user.active?
        redirect_to login_path, notice: t('.already_active')
      end
    end

    def mark_notifications_as_viewed
      @notifications.where(viewed: false).each { |n| n.update(viewed: true) }
    end
end
