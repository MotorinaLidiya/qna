class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :omniauthable,
         omniauth_providers: %i[github vkontakte]

  has_many :questions, class_name: 'Question', foreign_key: 'author_id', dependent: :destroy, inverse_of: :author
  has_many :answers, class_name: 'Answer', foreign_key: 'author_id', dependent: :destroy, inverse_of: :author
  has_many :comments, class_name: 'Comment', foreign_key: 'author_id', dependent: :destroy, inverse_of: :author
  has_many :rewards, dependent: :nullify
  has_many :reactions, dependent: :nullify
  has_many :authorizations, dependent: :destroy
  has_many :question_subscriptions, dependent: :destroy
  has_many :subscribed_questions, through: :question_subscriptions, source: :question

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def give_reward(question)
    return if rewards.exists?(question.reward.id)

    rewards << question.reward
  end

  def self.find_for_oauth(auth, email)
    FindOrCreateForOauthService.new(auth, email).call
  end

  def create_authorization(auth)
    authorizations.create!(provider: auth.provider, uid: auth.uid)
  end

  def self.find_or_create(email)
    password = password_confirmation = Devise.friendly_token[0, 20]
    user = find_by(email:) || new(email:, password:, password_confirmation:)
    user.save if user.new_record?
    user
  end

  def subscribed_to?(question)
    question_subscriptions.exists?(question: question)
  end

  def subscribe(question)
    question_subscriptions.create(question: question) unless subscribed_to?(question)
  end

  def unsubscribe(question)
    question_subscriptions.find_by(question: question)&.destroy
  end
end
