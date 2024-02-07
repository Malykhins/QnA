class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :gon_current_user

  check_authorization unless: :devise_controller?

  def gon_current_user
    gon.current_user_id = current_user&.id
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js { render status: :forbidden }
      format.json { render json: exception.message, status: :forbidden }
    end
  end
end
