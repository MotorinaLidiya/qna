require 'rails_helper'
require 'active_storage_validations/matchers'

RSpec.describe Reward, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user).optional(:true) }
  it { should have_one_attached(:image) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:image) }
  it { should validate_length_of(:title).is_at_most(50) }
end
