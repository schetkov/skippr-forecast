class InvoiceApprovalsController < ApplicationController
  def update
    @invoice = current_seller.invoices.where(id: params[:id]).first
    if valid_anticipated_pay_date?
      update_anticipated_pay_date
      @invoice.select!
      create_attachments
      analytics.track_invoice_submission
      flash[:success] = "Your invoice has been submitted for approval!"
    else
      flash[:warning] = "Please ensure the anticipated pay date is after the due date."
    end
    redirect_to seller_dashboard_path
  end

  private

  def valid_anticipated_pay_date?
    !anticipated_pay_date.nil? && anticipated_pay_date >= @invoice.due_date
  end

  def anticipated_pay_date
    date = params[:invoice][:anticipated_pay_date]
    Date.strptime(date, "%m/%d/%Y")
  rescue ArgumentError
    nil
  end

  def update_anticipated_pay_date
    if anticipated_pay_date
      @invoice.update(anticipated_pay_date: anticipated_pay_date)
    end
  end

  def create_attachments
    if attachment_params
      attachment_params.each do |attachment_url|
        Attachments::AttachmentCreator.new(
          file_attributes: cloudinary_attribute_builder(attachment_url),
          resource: @invoice
        ).call
      end
    end
  end

  def cloudinary_attribute_builder(attachment_url)
    Attachments::CloudinaryAttributeBuilder.new("misc" => attachment_url).call
  end

  def attachment_params
    params[:invoice][:misc]
  end
end
