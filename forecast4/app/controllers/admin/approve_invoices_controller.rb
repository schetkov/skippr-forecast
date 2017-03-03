class Admin::ApproveInvoicesController < ApplicationController

  before_action :check_if_debtor_approved

  def update
    invoice = Invoice.find(params[:id])
    if invoice.rating.present?
      invoice.approve!
      flash[:notice] = "Invoice ##{invoice.id} has been approved."
      redirect_to admin_invoices_url(scope: 'approved')
    else
      flash[:warning] = "Please apply rating to invoice"
      redirect_to admin_invoices_url
    end
  end

  private

  def check_if_debtor_approved
    invoice = Invoice.find(params[:id])
    if !invoice.debtor.approved?
      flash[:warning] = " Please approve #{invoice.debtor.legal_business_name} first."
      redirect_to admin_invoices_path
    end
  end
end
