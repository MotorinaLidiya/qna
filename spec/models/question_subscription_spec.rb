require 'rails_helper'

RSpec.describe QuestionSubscription, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  subject { create(:question_subscription) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:question_id) }
end
