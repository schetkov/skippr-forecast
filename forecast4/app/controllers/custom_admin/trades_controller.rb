class CustomAdmin::TradesController < ApplicationController
  layout "admin"

  before_action :authenticate_admin_user!

  def index
    @trades = Trade.order(created_at: :desc)
  end

  def show
    @trade = Trade.find(params[:id])
  end
end
