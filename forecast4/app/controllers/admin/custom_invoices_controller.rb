class Admin::CustomInvoicesController < ApplicationController
  def create
    @invoice = Invoice.new(invoice_params)
    if @invoice.save
      create_new_attachments
      create_invoice_rating
      flash[:notice] = 'The invoice has been updated.'
      redirect_to admin_invoice_path(@invoice)
    else
      flash[:warning] = "#{@invoice.errors.full_messages}"
      redirect_to new_admin_invoice_path
    end
  end

  def update
    @invoice = Invoice.find(params[:id])
    create_new_attachments
    create_invoice_rating
    if @invoice.update(invoice_params)
      flash[:notice] = 'The invoice has been updated.'
    else
      flash[:warning] = 'Sorry there was an error updating this invoice.'
    end
    redirect_to admin_invoice_path(@invoice)
  end

  # TODO: Controller spec
  def destroy
    invoice = Invoice.find(params[:invoice_id])
    ppsr = Ppsr.find(params[:id])
    ppsr.destroy
    redirect_to admin_invoice_path(invoice)
  end

  private

  def invoice_params
    params.require(:invoice).permit(
      :debtor_id,
      :seller_id,
      :invoice_no,
      :face_value,
      :purchase_order_number,
      :date,
      :due_date,
      :anticipated_pay_date,
      :description,
      :discounts_offered,
      :funding_status,
      :service_rendered,
      :customer_satisfied,
      :payment_to_be_sent,
      :admin_funding_status_notes,
      :payment_status,
      :amount_paid_by_debtor,
      :paid_on,
      :funded_on,
      :admin_general_notes,
      :payment_period,
      :payment_period_paid,
      :buyer_discount_fee,
      :buyer_discount_fee_paid,
      :buyers_cumulative_daily_charges,
      :buyers_cumulative_daily_charges_paid,
      :buyers_upfront_payment,
      :buyers_upfront_payment_paid,
      :sellers_rebate,
      :sellers_rebate_paid,
      :seller_exchange_fee,
      :seller_exchange_fee_paid,
      :buyer_exchange_fee,
      :buyer_exchange_fee_paid,
      :rating_value,
      :workflow_state
    )
  end

  def create_new_attachments
    Attachments::AttachmentCreator.new(
      file_attributes: cloudinary_attribute_builder,
      resource: @invoice
    ).call
  end

  def cloudinary_attribute_builder
    Attachments::CloudinaryAttributeBuilder.new(params[:invoice]).call
  end

  def create_invoice_rating
    if params[:invoice][:rating_value].present?
      Invoices::RatingApplier.new(@invoice, params[:invoice][:rating_value]).call
    end
  end
end
