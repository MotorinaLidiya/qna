require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
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

      it 'redirects to question show view' do
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

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  # describe 'PATCH #update' do
  #   before { login(user) }
  #   context 'with valid attributes' do
  #     it 'assigns the requested answer to @answer' do
  #       patch :update, params: { id: answer, answer: attributes_for(:answer) }
  #       expect(assigns(:answer)).to eq answer
  #     end
  #
  #     it 'changes answer attributes' do
  #       patch :update, params: { id: answer, answer: { body: 'new body' } }
  #       answer.reload
  #       expect(answer.body).to eq 'new body'
  #     end
  #
  #     it 'redirects to question show view' do
  #       post :create, params: { answer: attributes_for(:answer), question_id: question }
  #       expect(response).to redirect_to assigns(:question)
  #     end
  #   end
  #
  #   context 'with invalid attributes' do
  #     before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }
  #
  #     it 'does not change answer' do
  #       answer.reload
  #       expect(answer.body).to eq 'MyString'
  #     end
  #
  #     it { is_expected.to render_template(:edit) }
  #   end
  # end

  describe 'DELETE #destroy' do
    let(:second_user) { create(:user) }
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'author of the answer' do
      before { login(user) }
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
        expect(flash[:notice]).to eq 'Answer was successfully deleted.'
      end
    end

    context 'not the author of the answer' do
      before { login(second_user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to index with alert' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
        expect(flash[:alert]).to eq 'You have no rights to perform this action.'
      end
    end
  end
end
