class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]

  def edit
    answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer was successfully created.'
    else
      @answers = @question.answers.includes(:author).order(:created_at)
      render 'questions/show'
    end
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

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer
    @answer = Answer.find(params[:id])
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
