require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should have_many_attached(:files) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_most(300) }

  it { should accept_nested_attributes_for :links }
end
