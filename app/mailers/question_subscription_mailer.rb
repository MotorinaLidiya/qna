class QuestionSubscriptionMailer < ApplicationMailer
  def digest(user, question)
    @question = question
    @answer = question.answers.last

    mail to: user.email, subject: "New Answer for #{question.title}"
  end
end
