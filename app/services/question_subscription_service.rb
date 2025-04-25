class QuestionSubscriptionService
  def send_digest(question)
    answer_author = question.answers.last&.author

    question.subscribers.find_each do |user|
      QuestionSubscriptionMailer.digest(user, question).deliver_later if user != answer_author
    end
  end
end
