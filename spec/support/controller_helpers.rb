module ControllerHelpers
  def login(user)
    @request.env['devise.mepping'] = Devise.mappings[:user]
    sign_in(user)
  end
end
