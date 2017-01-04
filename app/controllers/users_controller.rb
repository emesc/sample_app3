class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  # before_action :find_user, only: [:show, :destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # log_in @user   # log in upon sign up
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile successfully updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User successfully deleted"
    redirect_to users_url 
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # def find_user
    #   @user = User.find(params[:id])
    # end

    # before filter

    # confirms a logged_in user
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # confirms admin user
    def admin_user
      redirect_to(root_url) unless (current_user && current_user.admin?)
    end
end
