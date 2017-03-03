class Sellers::AttachmentsController < ApplicationController

  def create
    @seller = Seller.find(params[:seller_id])
    if new_attachment
      flash[:success] = "Your attachment was successfully uploaded."
    else
      flash[:danger] = "Oops! There was an error uploading your attachment."
    end
    redirect_to :back
  end

  private

  def new_attachment
    Attachments::AttachmentCreator.new(
      file_attributes: cloudinary_attribute_builder,
      resource: @seller.seller_company
    ).call
  end

  def cloudinary_attribute_builder
    Attachments::CloudinaryAttributeBuilder.new(attachment_params).call
  end

  def attachment_params
    params[:attachment]
  end
end
