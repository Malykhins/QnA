# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down unvote]
  end

  def vote_up
    return render_error if cannot?(:vote_up, @votable) || @votable.voted?(current_user)

    @votable.vote_up(current_user)
    render_json
  end

  def vote_down
    return render_error if cannot?(:vote_down, @votable) || @votable.voted?(current_user)

    @votable.vote_down(current_user)
    render_json
  end

  def unvote
    return render_error if cannot?(:unvote, @votable)

    @votable.unvote(current_user)
    render_json
  end

private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def render_error
    render json: { error_message: 'Error: You are the author of the question or you have already voted!',
                   resource_name: @votable.class.name.downcase,
                   resource_id: @votable.id }, status: :forbidden
  end

  def render_json
    render json: { rating: @votable.vote_rating,
                   resource_name: @votable.class.name.downcase,
                   resource_id: @votable.id,
                   already_voted: @votable.voted?(current_user)}
  end
end
