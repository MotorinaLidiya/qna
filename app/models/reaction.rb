class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :reactionable, polymorphic: true

  validates :value, presence: true, inclusion: { in: [-1, 0, 1] }
  validates :user, uniqueness: { scope: :reactionable, message: 'has already put a reaction' }
  validate :unable_react_on_own_content

  def like?
    value == 1
  end

  def dislike?
    value == -1
  end

  private

  def unable_react_on_own_content
    return if reactionable.nil?
    return unless reactionable.author == user

    errors.add(:user, 'Cannot react on your own content')
  end
end
