FactoryBot.define do
  factory :answer do
    body { 'MyString' }
    question
    author

    trait :invalid do
      body { nil }
    end
  end
end
