class FindOrCreateForOauthService
  attr_reader :auth, :email

  def initialize(auth, email)
    @auth = auth
    @email = email
  end

  def call
    user = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)&.user
    return user if user

    password = Devise.friendly_token[0, 20]
    user = User.find_by(email:) || User.create!(email:, password:, password_confirmation: password)
    user.create_authorization(auth)
    user
  end
end
