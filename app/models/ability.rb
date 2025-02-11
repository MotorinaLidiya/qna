class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
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

    can :me, User, id: user.id
  end
end
