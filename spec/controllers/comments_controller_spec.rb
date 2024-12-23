require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    before { login(user) }

    context 'creating a comment for a question' do
      it 'creates a new comment' do
        expect {
          post :create, params: { commentable: 'questions', user_id: user, question_id: question, comment: attributes_for(:comment) }, format: :js
        }.to change(Comment, :count).by(1)

        expect(assigns(:comment).commentable).to eq(question)
        expect(assigns(:comment).author).to eq(user)
        expect(response).to render_template :create
      end
    end

    context 'creating a comment for an answer' do
      it 'creates a new comment' do
        expect {
          post :create, params: { commentable_type: 'answers', user_id: user, answer_id: answer, comment: attributes_for(:comment) }, format: :js
        }.to change(Comment, :count).by(1)

        expect(assigns(:comment).commentable).to eq(answer)
        expect(assigns(:comment).author).to eq(user)
        expect(response).to render_template :create
      end
    end

    context 'creating an invalid comment' do
      it 'does not create a comment' do
        expect {
          post :create, params: { commentable_type: 'questions', user_id: user, question_id: question, comment: { body: '' } }, format: :js
        }.not_to change(Comment, :count)

        expect(assigns(:comment).errors).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:comment) { create(:comment, commentable: question, author: user) }

    it 'deletes the comment' do
      expect {
        delete :destroy, params: { commentable_type: 'questions', user_id: user, question_id: question, id: comment }, format: :js
      }.to change(Comment, :count).by(-1)
    end
  end
end
