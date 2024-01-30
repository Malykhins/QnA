class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    render json: @questions
  end
end