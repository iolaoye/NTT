class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "NTT Password Reset"
  end
  def fields_simulated(user, msg)
    @user = user
    mail to: @user.email, subject: "NTT message", body: msg
  end
  def email_with_att(user, msg, file)
    attachments["attachment.csv"] = File.read(file)
    @user = user
    mail to: @user.email, subject: "NTT message", body: msg
  end
end
