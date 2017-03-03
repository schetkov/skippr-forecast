class Admin::SendInvoiceEmailsController < ApplicationController
  def create
    invoice = Invoice.find(params[:id])
    invoice.seller.payment_status_notification!(invoice)
    invoice.auction.winning_bid.buyer.payment_status_notification!(invoice)
    flash[:notice] = "A payment status update has been sent to the seller & buyer"
    redirect_to :back
  end
end
