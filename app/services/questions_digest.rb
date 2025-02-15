class QuestionsDigest
  def send_digest
    User.find_each(batch_size: 500) do |user|
      QuestionsDigestMailer.digest(user).deliver_later
    end
  end
end
