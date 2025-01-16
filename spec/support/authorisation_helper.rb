module OmniauthMacros
  def mock_auth(provider, email = nil)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      provider: provider,
      uid: '123',
      info: { name: 'Name', email: }
    )
  end
end
