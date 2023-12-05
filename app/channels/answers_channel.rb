class AnswersChannel < ApplicationCable::Channel
  def subscribed
    @question = Question.find_by_id(params[:id])

    if @question
      stream_for @question
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  #
  # def get_user_data
  #   data = {
  #     id: current_user.id,
  #     email: current_user.email
  #   }
  #
  #   AnswersChannel.broadcast_to(@question, user: data)
  # end
end
