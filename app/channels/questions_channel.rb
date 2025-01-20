class QuestionsChannel < ApplicationCable::Channel
  authorize_resource

  def subscribed
    stream_from 'questions' if can? :read, Question
  end
end
