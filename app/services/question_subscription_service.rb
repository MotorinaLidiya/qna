class QuestionSubscriptionService
  def send_digest(question)
    question.subscribers.find_each do |user|
      QuestionSubscriptionMailer.digest(user, question).deliver_later
    end
  end
end
