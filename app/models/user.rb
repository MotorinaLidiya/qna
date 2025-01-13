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

  def give_reward(question)
    return if rewards.exists?(question.reward.id)

    rewards << question.reward
  end

  def self.find_for_oauth(auth, email)
    FindForOauthService.new(auth, email).call
  end

  def create_authorization(auth)
    authorizations.create!(provider: auth.provider, uid: auth.uid)
  end

  def self.create_user(email)
    password = Devise.friendly_token[0, 20]
    User.create!(email:, password:, password_confirmation: password)
  end
end
