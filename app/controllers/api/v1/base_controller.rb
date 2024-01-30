class Api::V1::BaseController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :doorkeeper_authorize!

  private

  def current_resource_owner
    if doorkeeper_token
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
    else
      warden.authenticate(scope: :user)
    end
  end
end