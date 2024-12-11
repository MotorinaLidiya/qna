require 'rails_helper'

RSpec.describe Reaction, type: :model do
  it { should belong_to :reactionable }
  it { should belong_to :user }

  it { should validate_presence_of :value }

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, author: another_user) }

  it 'validates uniqueness of user reaction' do
    create(:reaction, user: user, reactionable: question, value: 1)

    new_reaction = build(:reaction, user: user, reactionable: question, value: -1)
    expect(new_reaction).not_to be_valid
    expect(new_reaction.errors[:user]).to include('has already put a reaction')
  end

  it 'does not allow a user to react on his own content' do
    reaction = build(:reaction, user: another_user, reactionable: question, value: 1)
    expect(reaction).not_to be_valid
    expect(reaction.errors[:user]).to include('Cannot react on your own content')
  end

  it 'is valid when a user reacts on someone else content' do
    reaction = build(:reaction, user: user, reactionable: question, value: 1)
    expect(reaction).to be_valid
  end
end
