class QuestionsDigestMailerPreview < ActionMailer::Preview
  def digest
    QuestionsDigestMailer.digest(user)
  end
end
