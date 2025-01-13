class UserMailer < ApplicationMailer
  def confirm_email(user)
    @user = user
    @confirmation_url = confirm_email_url(token: @user.confirmation_token)

    mail(to: @user.email, subject: 'Please confirm your email address')
  end
end
