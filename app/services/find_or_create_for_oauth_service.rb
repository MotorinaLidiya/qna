class FindOrCreateForOauthService
  attr_reader :auth, :email

  def initialize(auth, email)
    @auth = auth
    @email = email
  end

  def call
    user = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)&.user
    return user if user

    user = User.find_or_create(email)
    user.create_authorization(auth)
    user
  end
end
