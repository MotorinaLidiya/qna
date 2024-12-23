class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  def create
    @commentable = set_commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.author = current_user
    @comment.save
  end

  def destroy
    @commentable = set_commentable
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy if @comment.author == current_user
  end

  private

  def set_commentable
    if params[:question_id]
      Question.find(params[:question_id])
    elsif params[:answer_id]
      Answer.find(params[:answer_id])
    elsif params[:id]
      comment = Comment.find_by(id: params[:id])
      @commentable = comment&.commentable
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    question_id = @comment.commentable.is_a?(Question) ? @comment.commentable.id : @comment.commentable.question_id

    broadcast_comment(question_id)
  end

  def broadcast_comment(question_id)
    html = ApplicationController.render(
      partial: 'comments/comment',
      locals: { comment: @comment, current_user: }
    )

    ActionCable.server.broadcast(
      "questions/#{question_id}/comments",
      {
        html:, comment_id: @comment.id, body: @comment.body, user_id: current_user.id, question_id:,
        commentable_type: @comment.commentable_type, commentable_id: @comment.commentable.id
      }
    )
  end
end
