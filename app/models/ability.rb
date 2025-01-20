# frozen_string_literal: true

class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user
    user ? user_abilities : guest_abilities
  end

  def guest_abilities
    can :read, [Question]
  end

  def user_abilities
    can :read, [Question, Answer, Comment]

    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], author_id: user.id
    can :destroy, [Question, Answer, Comment], author_id: user.id

    can(%i[like dislike], Reaction) { |reaction| reaction.reactionable.author_id != user.id }
    can(%i[like dislike], [Question, Answer]) { |resource| resource.author_id != user.id }

    can(:make_best, Answer) { |answer| answer.question.author_id == user.id }

    can :rewards, User, id: user.id

    can(:destroy, ActiveStorage::Attachment) { |attachment| attachment.record.author_id == user.id }

    can(:destroy, Link) { |link| link.linkable.author_id == user.id }

    can :manage, :session if user.present?
  end
end
