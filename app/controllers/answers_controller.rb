class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(author: current_user, **answer_params)
  end

  def update
    @question = answer.question
    if answer.update(answer_params.except(:files)) && params[:answer][:files].present?
      @answer.files.attach(params[:answer][:files])
    end
    @answer.reload
  end

  def destroy
    answer.destroy if answer.author == current_user
  end

  def make_best
    @question = answer.question
    return unless @question.author == current_user

    answer.mark_as_best
    @answers = @question.answers.sort_by_best
  end

  private

  def answer
    @answer ||= Answer.with_attached_files.find(params[:id])
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
