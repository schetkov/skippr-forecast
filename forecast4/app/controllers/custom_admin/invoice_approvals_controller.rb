class CustomAdmin::InvoiceApprovalsController < ApplicationController
  before_action :authenticate_admin_user!

  def create
    @invoice = Invoice.find(params[:id])
    @invoice.approve!
    flash[:success] = "Invoice #{@invoice.id} has been approved!"
    redirect_to custom_admin_invoice_path(@invoice)
  end
end
