FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'Test' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { 'uid12345678' }
    secret { 'secret876543212' }
  end
end
