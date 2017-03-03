class Debtors::AttachmentsController < ApplicationController
  before_action :authorize_destroy, only: [:destroy]

  def create
    @debtor = Debtor.find(params[:debtor_id])
    create_new_attachment
    redirect_to seller_debtor_path(@debtor.seller, @debtor)
  end

  def destroy
    customer_receipt = @debtor.attachments.where(id: params[:id]).first
    customer_receipt.destroy
    # TODO: Make this available in service class
    Cloudinary::Uploader.destroy(customer_receipt.file_name)
    flash[:success] = "Your debtor's customer receipt has been deleted."
    redirect_to seller_debtor_path(@debtor.seller, @debtor)
  end

  private

  def authorize_destroy
    @debtor = Debtor.find(params[:debtor_id])
    if current_user.account != @debtor.seller
      flash[:warning] = "Your're not authorized to do that."
      redirect_to seller_debtor_path(@debtor.seller, @debtor)
    end
  end

  def create_new_attachment
    Attachments::AttachmentCreator.new(
      file_attributes: cloudinary_attribute_builder,
      resource: @debtor
    ).call
  end

  def cloudinary_attribute_builder
    Attachments::CloudinaryAttributeBuilder.new(attachment_params).call
  end

  def attachment_params
    params[:attachment]
  end
end
