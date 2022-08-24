class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      check_user_activation user
    else
      flash.now[:danger] = t "error.login_failed"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def check_user_activation user
    if user.activated?
      log_in user
      to_be_remembered? user
      redirect_back_or user
    else
      flash[:warning] = t "user.not_activated_warn"
      redirect_to root_url
    end
  end
end
