# frozen_string_literal: true

class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_question, only: %i[show update destroy]
  before_action :find_questions, only: %i[index update]
  after_action :public_question, only: :create

  include Voted

  def index; end

  def show
    @answers = @question.answers.sort_by_best
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    return head(403) unless current_user.author_of?(@question)

    if @question.update(question_params)
      params[:question][:remove_files]&.each do |file_id|
        @question.files.find_by_id(file_id)&.purge
      end

      flash.now[:notice] = 'Your question successfully updated!'
    else
      flash.now[:error] = 'Error updating a question!'
    end
  end

  def destroy
    return head(403) unless current_user.author_of?(@question)

    @question.files.purge
    @question.destroy

    redirect_to questions_path, notice: 'Your question successfully deleted.'
  end

private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[id name url _destroy],
                                     reward_attributes: [:title, :image])
  end

  def find_questions
    @questions = Question.all
  end

  def public_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions_channel', partial:
      ApplicationController.render(partial: 'questions/question',
                                   locals: { question: @question, current_user: nil }))
  end
end
