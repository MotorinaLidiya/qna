require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create(:question, author: user) }
    let(:other_question) { create(:question, author: other) }
    let(:answer) { create(:answer, author: user, question:) }
    let(:other_answer) { create(:answer, author: other, question: other_question) }
    let(:comment) { create(:comment, author: user, commentable: question) }
    let(:other_comment) { create(:comment, author: other, commentable: question) }

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    context 'for question' do
      it { should be_able_to %i[update destroy], question }
      it { should_not be_able_to %i[update destroy], other_question }
      it { should_not be_able_to %i[like dislike], question }
      it { should be_able_to %i[like dislike], other_question }
    end

    context 'for answer' do
      it { should be_able_to %i[update make_best destroy], answer }
      it { should_not be_able_to %i[update make_best destroy], other_answer }
      it { should_not be_able_to %i[like dislike], answer }
      it { should be_able_to %i[like dislike], other_answer }
    end

    context 'for reactions' do
      it { should_not be_able_to %i[like dislike], build(:reaction, user:, reactionable: question) }
      it { should be_able_to %i[like dislike], build(:reaction, user:, reactionable: other_question) }
    end

    context 'for comment' do
      it { should be_able_to :destroy, comment }
      it { should_not be_able_to :destroy, other_comment }
    end

    context 'for rewards' do
      it { should be_able_to :rewards, user }
      it { should_not be_able_to :rewards, other }
    end

    context 'for attachments' do
      it { should be_able_to :destroy, ActiveStorage::Attachment }
    end

    context 'for links' do
      let(:link) { create(:link, linkable: question) }
      let(:other_link) { create(:link, linkable: other_question) }

      it { should be_able_to :destroy, link }
      it { should_not be_able_to :destroy, other_link }
    end

    context 'when user is present' do
      let(:user) { create(:user) }

      it 'allows managing session' do
        expect(ability).to be_able_to(:manage, :session)
      end
    end

    context 'when user is not present' do
      let(:user) { nil }

      it 'does not allow managing session' do
        expect(ability).not_to be_able_to(:manage, :session)
      end
    end
  end
end
