class CustomAdmin::Sellers::InvoicesController < ApplicationController
  layout "admin"

  before_action :authenticate_admin_user!

  def index
    @seller = Seller.find(params[:seller_id])
    @invoices = @seller.invoices
  end
end
