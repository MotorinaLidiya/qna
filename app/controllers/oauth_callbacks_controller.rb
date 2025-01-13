class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: [:confirm_email]

  def github
    set_auth
    set_email
    handle_auth(@auth, @email)
  end

  def vkontakte
    set_auth
    set_email

    session[:uid] = @auth['uid']
    session[:provider] = @auth['provider']
    return render 'shared/email_confirmation' unless @email

    handle_auth(@auth, @email)
  end

  def confirm_email
    email = params[:email]
    uid = session[:uid]
    provider = session[:provider]

    return unless valid_email?(email)

    user = User.find_by(email:) || User.create_user(email)
    user.authorizations.create!(provider:, uid: uid.to_s) if user && provider && uid
    confirm_message(user)
  end

  private

  def handle_auth(auth, email)
    @user = User.find_for_oauth(auth, email)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def set_auth
    @auth = request.env['omniauth.auth']
  end

  def set_email
    @email = @auth.info[:email] || Authorization.find_by(provider: @auth.provider, uid: @auth.uid.to_s)&.user&.email
  end

  def valid_email?(email)
    email.present? && email.match?(URI::MailTo::EMAIL_REGEXP)
  end

  def confirm_message(user)
    if user.confirmed?
      redirect_to user_session_path, notice: 'You can log in'
    else
      redirect_to user_session_path, notice: "Email has been sent to #{user.email} for confirmation"
    end
  end
end
