class CustomAdmin::AllocateFundsController < ApplicationController
  before_action :authenticate_admin_user!

  def create
    invoice = Invoice.find(params[:id])
    buyer = Buyer.find(params[:buyer_id])
    invoice.update(buyer: buyer)
    Funds::FundAllocator.new(buyer, invoice).call

    flash[:success] = "Invoice has been allocated to #{buyer.name}."
    redirect_to custom_admin_invoice_path(invoice)
  end
end
