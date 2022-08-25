class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailer.sbj")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("mailer.sbj_pw_reset")
  end
end
