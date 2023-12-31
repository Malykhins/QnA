# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy update set_best edit]
  after_action :public_answer, only: :create

  authorize_resource

  include Voted
  include Commented

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))

    if @answer.persisted?
      flash.now[:notice] = 'Your answer successfully created!'
    else
      flash.now[:error] = 'Error creating an answer!'
    end
  end

  def destroy
    return head(302) unless can? :destroy, @answer

    @answer.files.purge
    @answer.destroy

    if @answer.destroyed?
      @answers = @answer.question.answers
      flash.now[:notice] = 'Your answer successfully deleted!'
    else
      flash.now[:error] = 'Error answer not deleted!'
    end
  end

  def update
    return head(403) unless can? :update, @answer

    if @answer.update(answer_params)
      params[:answer][:remove_files]&.each do |file_id|
        @answer.files.find_by_id(file_id)&.purge
      end

      flash.now[:notice] = 'Your answer was successfully updated!'
    else
      flash.now[:error] = 'Error updating the answer!'
    end
  end

  def set_best
    return head(403) unless (can? :set_best, @answer) || params[:answer][:best].present?

    @answer.mark_as_best(params[:answer][:best])

    flash.now[:notice] = 'Best answer status updated successfully!'
  end

private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :best, files: [], links_attributes: %i[id name url _destroy])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answers
    @answers = Answer.all
  end

  def public_answer
    return if @answer.errors.any?

    AnswersChannel.broadcast_to(@question, partial:
      ApplicationController.render(partial: 'answers/answer_broadcast',
                                   locals: { answer: @answer, current_user: current_user }),
                                answer_author_id: current_user.id,
                                answer_id: @answer.id)
  end
end
