class Admin::CreditReportsController < ApplicationController
  def create
    @seller = Seller.find(params[:seller_id])
    create_new_attachment
    redirect_to edit_admin_seller_path(@seller)
  end

  def destroy
    seller = Seller.find(params[:seller_id])
    credit_report = seller.attachments.where(id: params[:id]).first
    # TODO: Destroy it on S3 as well
    credit_report.destroy
    redirect_to edit_admin_seller_path(seller)
  end

  private

  def create_new_attachment
    Attachments::AttachmentCreator.new(
      file_attributes: cloudinary_attribute_builder,
      resource: @seller
    ).call
  end

  def cloudinary_attribute_builder
    Attachments::CloudinaryAttributeBuilder.new(params[:seller]).call
  end
end
