class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(author: current_user, **answer_params)
  end

  def update
    @question = answer.question
    remove_files if params[:remove_files].present?
    update_answer
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
    params.require(:answer).permit(:body, files: [])
  end

  def remove_files
    answer.remove_files(params[:remove_files])
  end

  def update_answer
    answer_is_valid = answer.update(answer_params.except(:files))
    answer.files.attach(answer_params[:files]) if answer_is_valid && answer_params[:files].present?
  end
end
