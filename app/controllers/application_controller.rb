class ApplicationController < ActionController::Base

  before_action :authenticate_user!
  before_action :gon_current_user

  check_authorization unless: :devise_controller?

  def gon_current_user
    gon.current_user_id = current_user&.id
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

end
