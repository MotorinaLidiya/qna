module Reactionable
  extend ActiveSupport::Concern
  included do
    has_many :reactions, as: :reactionable, dependent: :nullify
  end

  def reaction_rating
    reactions.sum(:value)
  end
end
