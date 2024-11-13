require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answers) { create_list(:answer, 3, question: question, author: user) }
  let(:answer) { answers.first }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        end.to change(Answer, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        end.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'MyString'
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #make_best' do
    let(:second_user) { create(:user) }
    let(:answer_second) { answers.second }

    context 'author of the question' do
      before do
        login(user)
        patch :make_best, params: { id: answer }, format: :js
      end

      it 'makes answer best' do
        expect(answer.reload).to be_best
        expect(answer_second.reload).not_to be_best
      end

      it 'renders make_best template' do
        expect(response).to render_template :make_best
      end
    end

    context 'not author of the question' do
      before do
        login(second_user)
        patch :make_best, params: { id: answer_second }, format: :js
      end

      it 'does not mark answer as best' do
        expect(answer_second.reload).not_to be_best
      end

      it 'renders make_best template' do
        expect(response).to render_template :make_best
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:second_user) { create(:user) }
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'author of the answer' do
      before { login(user) }
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not the author of the answer' do
      before { login(second_user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer, author: user }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
