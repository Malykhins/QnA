class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :gon_current_user

  def gon_current_user
    gon.current_user_id = current_user&.id
  end
end
