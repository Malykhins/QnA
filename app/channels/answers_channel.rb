# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def subscribed
    @question = Question.find_by_id(params[:id])

    if @question
      stream_for @question
    else
      reject
    end
  end

  def unsubscribed; end
end
