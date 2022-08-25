class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "forgot_pw.email_sent_noti"
      redirect_to root_url
    else
      flash.now[:danger] = t "error.email_add_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "error.pw_empty")
      render :edit
    elsif @user.update(user_params)
      user = @user
      reset_and_login user
    else
      flash.now[:danger] = t "error.pw_res_failed"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Before filters

  def get_user
    @user = User.find_by(email: params[:email])
    return if @user

    redirect_to root_path, flash[:danger] = t("error.usr_not_found")
  end

  # Confirms a valid user.
  def valid_user
    return if @user&.activated && @user&.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "error.res_link_expired"
    redirect_to new_password_reset_url
  end

  def reset_and_login user
    log_in user
    user.update_attribute(:reset_digest, nil)
    flash[:success] = t "pw_res.noti"
    redirect_to user
  end
end
