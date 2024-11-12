class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.includes(:author, :answers)
  end

  def show
    @answers = question.answers.includes(:author).sort_by_best
    @answer = Answer.new
  end

  def new
    question
  end

  def edit
    question
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def update
    remove_files if params[:remove_files].present?
    update_question
    @question.reload
  end

  def destroy
    if question.author == current_user
      question.destroy
      redirect_to questions_path, notice: 'Question was successfully deleted.'
    else
      redirect_to question_path, alert: 'You have no rights to perform this action.'
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def remove_files
    question.remove_files(params[:remove_files])
  end

  def update_question
    question_is_valid = question.update(question_params.except(:files))
    question.files.attach(question_params[:files]) if question_is_valid && question_params[:files].present?
  end
end
