class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path, flash[:danger] = t("error.usr_not_found")
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = t "home.welcome_message"
      redirect_to @user
    else
      flash[:danger] = t "error.signup_failed"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
