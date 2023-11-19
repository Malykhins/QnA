# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def voted?(user)
    votes.exists?(user: user)
  end

  def vote_up(user)
    votes.create!(user: user, value: 1)
  end

  def vote_down(user)
    votes.create!(user: user, value: -1)
  end

  def unvote(user)
    votes.where(user: user)&.destroy_all
  end

  def vote_rating
    votes.sum(:value)
  end
end
