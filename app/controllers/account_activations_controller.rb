class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if check_user_state user
      user.activate
      log_in user
      flash[:success] = t "user.activated_noti"
      redirect_to user
    else
      flash[:danger] = t "error.invalid_activation_link"
      redirect_to root_url
    end
  end

  private

  # Ket qua cua ham nay se dung cho phuong thuc "edit" ben tren.
  def check_user_state user
    user && !user.activated? && user.authenticated?(:activation,
                                                    params[:id])
  end
end
