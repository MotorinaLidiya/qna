class ReactionsController < ActionController::API
  before_action :authenticate_user!

  def like
    set_reactionable
    action('like')
  end

  def dislike
    set_reactionable
    action('dislike')
  end

  private

  def set_reactionable
    @reactionable = params[:reactionable_type].constantize.find(params[:reactionable_id])
  end

  def action(kind)
    @reaction = @reactionable.reactions.find_by(user: current_user)

    if @reaction.present? && @reaction.kind == kind
      @reaction.destroy
    elsif @reaction.present?
      @reaction.update(kind:)
    else
      @reactionable.reactions.create(kind: kind, user: current_user)
    end

    render json: { rating: @reactionable.reaction_rating }
  end
end
