# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy update set_best]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))

    if @answer.persisted?
      flash.now[:notice] = 'Your answer successfully created!'
    else
      flash.now[:error] = 'Error creating an answer!'
    end
  end

  def destroy
    return unless current_user.author_of?(@answer)

    @answers = Answer.all

    @answer.files.purge
    @answer.destroy

    if @answer.destroyed?
      flash.now[:notice] = 'Your answer successfully deleted!'
    else
      flash.now[:error] = 'Error answer not deleted!'
    end
  end

  def update
    return unless current_user.author_of?(@answer)

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
    return unless current_user.author_of?(@answer.question) || params[:answer][:best].present?

    @answer.mark_as_best(params[:answer][:best])

    flash.now[:notice] = 'Best answer status updated successfully!'
  end

private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
  def answer_params
    params.require(:answer).permit(:body, :best, files: [], links_attributes: [:name, :url])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
