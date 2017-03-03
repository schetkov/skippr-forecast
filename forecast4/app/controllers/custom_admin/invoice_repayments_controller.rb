class CustomAdmin::InvoiceRepaymentsController < ApplicationController
  def create
    invoice = Invoice.find(params[:id])
    if invoice_to_be_paid_in_full?
      invoice_paid_in_full(invoice)
    else
      invoice_paid_in_short(invoice)
    end
    Funds::FundRepayer.new(invoice).call

    redirect_to custom_admin_invoice_path(invoice)
  end

  private

  def invoice_to_be_paid_in_full?
    params[:repayment_type] == "full"
  end

  def invoice_paid_in_full(invoice)
    invoice.update(
      payment_status: "Paid in Full",
      paid_on: Date.current,
      workflow_state: "repaid"
    )
  end

  def invoice_paid_in_short(invoice)
    invoice.update(
      payment_status: "Paid in Short",
      paid_on: Date.current,
      workflow_state: "repaid"
    )
  end
end
