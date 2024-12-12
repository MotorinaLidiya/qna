FactoryBot.define do
  factory :reaction do
    user
    reactionable { create(:question) }
    value { 1 }
  end
end
