require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_most(300) }
  it { should have_many_attached(:files) }
end
