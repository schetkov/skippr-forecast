class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_login

  add_flash_types :success, :info

  def admin?
    current_user && current_user.admin?
  end
  helper_method :admin?

  def authenticate_admin_user!
    redirect_to sign_in_path unless current_user && current_user.admin?
  end

  def current_seller
    if current_user
      @seller ||= current_user.seller
    end
  end
  helper_method :current_seller

  def current_buyer
    if current_user
      @buyer ||= current_user.buyer
    end
  end
  helper_method :current_buyer

  def current_root_path
    if current_user && current_user.seller?
      seller_dashboard_path
    elsif current_user && current_user.buyer?
      buyer_dealboard_path
    else
      signed_out_root_path
    end
  end
  helper_method :current_root_path

  def new_user_sign_up?
    if current_seller
      current_seller.new?
    elsif current_buyer
      current_buyer.new?
    end
  end

  def buyer_completed_registration_but_not_approved?
    if current_buyer
      current_buyer.completed?
    end
  end

  def analytics
    @analytics ||= Analytics::AnalyticsTracker.new(
      current_user,
      google_analytics_client_id
    )
  end

  def google_analytics_client_id
    google_analytics_cookie.gsub(/^GA\d\.\d\./, "")
  end

  def google_analytics_cookie
    cookies["_ga"] || ""
  end
end
