class QuestionSubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  authorize_resource

  def create
    current_user.subscribe(@question)
    redirect_to @question, notice: 'You have subscribed to this question.'
  end

  def destroy
    current_user.unsubscribe(@question)
    redirect_to @question, notice: 'You have unsubscribed from this question.'
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
