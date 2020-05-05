class UsersController < ApplicationController
  before_action :set_user, only: [:verify]
  #FIXME_AB: we should also check that user is not logged in to verify. You can make another before action ensure_not_logged_in
  skip_before_action :authorize, only: [:new, :create, :verify]
  before_action :check_if_already_activated, only: [:verify]

  # GET /users/new
  def new
    @user = User.new
  end

  def profile
    @user = current_user
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
        format.html { redirect_to profile_users_path, notice: t('.updated') }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :edit }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def verify
    if @user.activate(params[:token])
      redirect_to login_path, notice: t('.activated', name: @user.name)
    else
      redirect_to login_path, notice: t('.cannot_activate')
    end
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
end
