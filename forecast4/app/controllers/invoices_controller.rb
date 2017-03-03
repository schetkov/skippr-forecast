class InvoicesController < ApplicationController
  def index
    xero_authorisation = get_xero
    xero_authorisation.set_request_token
  end

  def show
    @invoice = current_seller.invoices.find_by(id: params[:id])
    if @invoice.nil?
      flash[:notice] = "You're not authorized to view that invoice."
      redirect_to invoices_path
    end
  end

  def new
    @debtor = current_seller.debtors.find_by(id: params[:debtor_id])
    @invoice = Invoice.new
  end

  def create
    @debtor = current_seller.debtors.find_by(id: params[:debtor_id])
    @invoice = @debtor.invoices.build(invoice_params)
    @invoice.seller = current_seller
    create_new_attachments

    if @invoice.save
      flash[:success] = 'Thank you for registering your invoice.'
      redirect_to invoices_path
      analytics.track_invoice_registration
    else
      render 'new'
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    if @invoice.trade.nil? || @invoice.trade.confirmed_at.nil?
      @invoice.destroy
      flash[:success] = 'Your invoice has been deleted'
    else
      flash[:danger] = 'Sorry you cannot delete this invoice as it is currently being used in a live trade'
    end
    redirect_to invoices_path
  end

  private

  def get_xero
    if current_seller.xero_authorisations.any?
      current_seller.xero_authorisations.last
    else
      current_seller.xero_authorisations.build(host: host_with_port)
    end
  end

  def host_with_port
    if Rails.env.test?
      "localhost:3000"
    else
      request.host_with_port
    end
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

  def invoice_params
    params.require(:invoice).permit(
      :invoice_no,
      :face_value,
      :purchase_order_number,
      :services_description,
      :merchandise_shipped_on,
      :merchandise_arrived_on,
      :shipping_company_url,
      :tracking_code,
      :services_started_on,
      :services_ended_on
    ).merge(
      date: date,
      due_date: due_date,
      anticipated_pay_date: anticipated_pay_date
    )
  end

  def date
    if params[:invoice][:date].present?
      Date.strptime(params[:invoice][:date], "%m/%d/%Y")
    end
  end

  def due_date
    if params[:invoice][:due_date].present?
      Date.strptime(params[:invoice][:due_date], "%m/%d/%Y")
    end
  end

  def anticipated_pay_date
    if params[:invoice][:anticipated_pay_date].present?
      Date.strptime(params[:invoice][:anticipated_pay_date], "%m/%d/%Y")
    end
  end

  def seller_company
    @seller.seller_company || NullCompany.new
  end
end
