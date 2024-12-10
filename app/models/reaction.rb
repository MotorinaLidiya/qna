class Reaction < ApplicationRecord
  enum kind: %i[like dislike]

  belongs_to :user
  belongs_to :reactionable, polymorphic: true

  validates :kind, presence: true
  validates :user, uniqueness: { scope: :reactionable, message: 'has already put a reaction' }
  validate :unable_react_on_own_content

  private

  def unable_react_on_own_content
    return unless reactionable&.author == user

    errors.add(:user, 'Cannot react on your own content')
  end
end
