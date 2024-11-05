class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(author: current_user, **answer_params)

  end

  def update
    if answer.update(answer_params)
      redirect_to @answer.question, notice: 'Answer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if answer.author == current_user
      answer.destroy
      redirect_to @answer.question, notice: 'Answer was successfully deleted.'
    else
      redirect_to @answer.question, alert: 'You have no rights to perform this action.'
    end
  end

  private

  def answer
    @answer = Answer.find(params[:id])
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
