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
    if question.update(question_params.except(:files)) && params[:question][:files].present?
      @question.files.attach(params[:question][:files])
    end
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
end
