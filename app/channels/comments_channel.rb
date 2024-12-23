class CommentsChannel < ApplicationCable::Channel
  def subscribed
    question_id = params[:question_id]
    stream_from "questions/#{question_id}/comments"
  end
end
