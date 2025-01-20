class ReactionsController < ActionController::API
  before_action :authenticate_user!

  authorize_resource

  def like
    reaction_action(value: 1)
  end

  def dislike
    reaction_action(value: -1)
  end

  private

  def reaction_action(value:)
    set_reactionable
    @reaction = @reactionable.reactions.find_or_initialize_by(user: current_user)

    if @reaction.new_record?
      @reaction.value = value
      @reaction.save
    elsif @reaction.value == value
      @reaction.destroy
    else
      @reaction.update(value:)
    end

    render json: { rating: @reactionable.reaction_rating }
  end

  def set_reactionable
    @reactionable = params[:reactionable_type].constantize.find(params[:reactionable_id])
  end
end
