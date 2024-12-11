FactoryBot.define do
  sequence :email do |n|
    "user-email#{n}@test.com"
  end

  factory :user, aliases: %i[author] do
    email { generate(:email) }
    password { '12345678' }
    password_confirmation { '12345678' }
  end
end
