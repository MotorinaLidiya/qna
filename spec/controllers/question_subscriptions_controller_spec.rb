require 'rails_helper'

RSpec.describe QuestionSubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { sign_in user }

  describe 'POST #create' do
    it 'subscribes the user to the question' do
      expect {
        post :create, params: { question_id: question.id }
      }.to change(user.question_subscriptions, :count).by(1)

      expect(response).to redirect_to(question)
      expect(flash[:notice]).to eq('You have subscribed to this question.')
    end
  end

  describe 'DELETE #destroy' do
    before { user.subscribe(question) }

    it 'unsubscribes the user from the question' do
      expect {
        delete :destroy, params: { question_id: question.id }
      }.to change(user.question_subscriptions, :count).by(-1)

      expect(response).to redirect_to(question)
      expect(flash[:notice]).to eq('You have unsubscribed from this question.')
    end
  end
end
