module ControllerHelpers
  def sign_in(user)
    allow(controller).to receive(:current_user) { user }
    allow(controller).to receive(:signed_in?) { true }
  end
end
