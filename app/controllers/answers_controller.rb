class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(author: current_user, **answer_params)
  end

  def update
    @question = answer.question
    answer.update(answer_params)
  end

  def destroy
    answer.destroy if answer.author == current_user
  end

  def make_best
    answer.mark_as_best
    @question = answer.question
    @answers = @question.answers.sort_by_best
  end

  private

  def answer
    @answer ||= Answer.find(params[:id])
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
