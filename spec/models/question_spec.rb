require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many_attached(:files) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:title).is_at_most(50) }
  it { should validate_length_of(:body).is_at_most(300) }

  it { should accept_nested_attributes_for :links }
end
