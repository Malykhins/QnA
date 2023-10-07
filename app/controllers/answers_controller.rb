class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy update]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))

    if @answer.persisted?
      flash.now[:notice] = 'Your answer successfully created!'
    else
      flash.now[:error] = 'Error creating an answer!'
    end
  end

  def destroy
    @answers = Answer.all

    @answer.destroy if current_user.author_of?(@answer)

    if @answer.persisted?
      flash.now[:error] = 'Error answer not deleted!'
    else
      flash.now[:notice] = 'Your answer successfully deleted!'
    end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)

    if @answer.persisted?
      flash.now[:notice] = 'Your answer successfully updated!'
    else
      flash.now[:error] = 'Error creating an answer!'
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
