class CustomAdmin::InvoicesController < ApplicationController
  layout "admin"

  before_action :authenticate_admin_user!

  def index
    if invoice_scope.present?
      @invoices = Invoice.send("with_#{invoice_scope}_state").
        order(created_at: :desc)
    else
      @invoices = Invoice.order(created_at: :desc)
    end
  end

  def show
    @invoice = Invoice.find(params[:id])
    @buyers = @invoice.potential_buyers
  end

  private

  def invoice_scope
    params[:p]
  end
end
