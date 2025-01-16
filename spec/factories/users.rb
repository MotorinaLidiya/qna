FactoryBot.define do
  sequence :email do |n|
    "user-email#{n}@test.com"
  end

  sequence :token do |n|
    "token_#{n}"
  end

  factory :user, aliases: %i[author] do
    email { generate(:email) }
    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { Time.zone.now }
    confirmation_sent_at { Time.zone.now }
    confirmation_token { generate(:token) }
  end
end
