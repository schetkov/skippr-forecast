class Sellers::DashboardsController < ApplicationController
  def show
    @dashboard = Dashboard.new(current_seller)
  end
end
