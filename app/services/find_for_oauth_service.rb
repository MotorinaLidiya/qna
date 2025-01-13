class FindForOauthService
  attr_reader :auth, :email

  def initialize(auth, email)
    @auth = auth
    @email = email
  end

  def call
    authorized_user = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)&.user
    user = User.find_by(email:) || authorized_user
    user ||= User.create_user(email)

    user.create_authorization(auth) unless authorized_user
    user
  end
end
