class UsersController < ApplicationController
  before_action :find_user_by_id, except: %i(index new create)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.activated_accounts.order("name ASC"),
                         items: Settings.pagy.usr_per_page)
  end

  def show
    @pagy, @microposts = pagy(@user.microposts,
                              items: Settings.pagy.micro_per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t "signup_page.noti"
      redirect_to @user
    else
      flash.now[:danger] = t "error.signup_failed"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "edit_page.updted"
      redirect_to @user
    else
      flash.now[:danger] = t "error.upd_failed"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "admin.rm_noti"
    else
      flash[:danger] = t "error.rm_failed"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Before filters

  # Confirms the correct user.
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def find_user_by_id
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path, flash[:danger] = t("error.usr_not_found")
  end
end
