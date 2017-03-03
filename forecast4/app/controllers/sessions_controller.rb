class SessionsController < Clearance::SessionsController

  layout "session"

  skip_before_action :require_login

protected

  def url_after_create
    analytics.track_user_sign_in(current_seller)
    if new_user_sign_up? || buyer_completed_registration_but_not_approved?
      redirect_user_back_to_homepage
    else
      Sessions::SessionRedirector.new(current_user).call
   end
  end

  def redirect_user_back_to_homepage
    sign_out
    flash[:warning] = "Your application is currently under review."
    signed_out_root_path
  end
end
