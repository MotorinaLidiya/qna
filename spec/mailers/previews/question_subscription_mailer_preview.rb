class QuestionSubscriptionMailerPreview < ActionMailer::Preview
  def digest
    QuestionSubscriptionMailer.digest(user, question)
  end
end
