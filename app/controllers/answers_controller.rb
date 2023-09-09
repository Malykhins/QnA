class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:show]
  before_action :set_question, only: [:new, :create]

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created!'
    else
      redirect_to @question, alert: "The body of the answer can't be blank"
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
