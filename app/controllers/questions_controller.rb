# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]
  before_action :find_questions, only: %i[index update]

  def index
  end

  def show
    @answers = @question.answers.sort_by_best
    @answer = Answer.new
  end

  def new
    @question = Question.new
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
    @question.update(question_params) if current_user.author_of?(@question)

    if @question.persisted?
      flash.now[:notice] = 'Your question successfully updated!'
    else
      flash.now[:error] = 'Error updating a question!'
    end
  end

  def destroy
    @question.destroy if current_user.author_of?(@question)
    redirect_to questions_path, notice: 'Your question successfully deleted.'
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def find_questions
    @questions = Question.all
  end
end
