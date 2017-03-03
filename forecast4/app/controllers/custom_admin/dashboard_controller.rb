class CustomAdmin::DashboardController < ApplicationController
  layout "admin"

  before_action :authenticate_admin_user!

  def index
  end
end
