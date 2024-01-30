# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    alias_action :vote_up, :vote_down, :unvote, to: :vote

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :me, User
    can :create, [Question, Answer]
    can :create_comment, [Question, Answer]
    can :vote, [Question, Answer] do |votable|
      votable.user_id != user.id
    end
    can [:update, :destroy], [Question, Answer], user_id: user.id
    can :set_best, Answer, question: { user_id: user.id }
    can :read, Reward, user_id: user.id

    can :destroy, Link do |link|
      (link.linkable_type == 'Question' && user.questions.pluck(:id).include?(link.linkable_id)) ||
        (link.linkable_type == 'Answer' && user.answers.pluck(:id).include?(link.linkable_id))
    end

    can :manage, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end
  end
end

