require 'rails_helper'

RSpec.describe ReactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'PATCH #like and #dislike' do
    before { login(user) }

    context 'when reacting to a resource' do
      it 'creates a new reaction if none exists' do
        expect { patch :like, params: { reactionable_type: 'Question', reactionable_id: question.id } }
          .to change(Reaction, :count).by(1)
      end

      it 'updates an existing reaction if the value changes' do
        patch :like, params: { reactionable_type: 'Question', reactionable_id: question.id }
        patch :dislike, params: { reactionable_type: 'Question', reactionable_id: question.id }

        expect(question.reactions.last.value).to eq(-1)
      end

      it 'destroys the reaction if the value is the same' do
        patch :like, params: { reactionable_type: 'Question', reactionable_id: question.id }
        expect { patch :like, params: { reactionable_type: 'Question', reactionable_id: question.id } }
          .to change(Reaction, :count).by(-1)
      end
    end
  end
end
