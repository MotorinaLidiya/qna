class AnswersChannel < ApplicationCable::Channel
  def subscribed
    question_id = params[:question_id]
    stream_from "questions/#{question_id}/answers"
  end
end
