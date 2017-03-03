class Admin::DebtorCreditReportsController < ApplicationController

  # This controller sucks - but the plan is to re-write all this stuff
  # in a custom admin section and rip out ActiveAdmin

  def update
    @debtor = Debtor.find(params[:id])
    create_new_attachment
    if @debtor.update(debtor_params)
      flash[:notice] = 'You have successfully edited your Debtor.'
    else
      flash[:warning] = 'Sorry there was an error updating this Debtor.'
    end
    redirect_to admin_debtor_path(@debtor)
  end

  # TODO: Write controller spec
  def destroy_credit_report
    debtor = Debtor.find(params[:debtor_id])
    credit_report = debtor.attachments.where(id: params[:id]).first
    credit_report.destroy
    flash[:notice] = 'Credit report has been deleted.'
    redirect_to admin_debtor_path(debtor)
  end

  def destroy_sales_agreement
    debtor = Debtor.find(params[:debtor_id])
    sales_agreement = debtor.attachments.where(id: params[:id]).first
    sales_agreement.destroy
    flash[:notice] = 'Sales agreement has been deleted.'
    redirect_to admin_debtor_path(debtor)
  end

  private

  def debtor_params
    params.require(:debtor).permit(
      :seller_id,
      :seller_company_id,
      :legal_business_name,
      :phone_number,
      :address,
      :acn,
      :website,
      :business_type,
      :business_sector,
      :relationship_start_date,
      :contact_name,
      :contact_phone_number,
      :internal_account_debtor_id,
      :customer_reference_id,
      :payment_processor,
      :other_name,
      :thirty_days,
      :sixty_days,
      :ninety_days,
      :over_ninety_days,
      :warranties,
      :progressive_billing,
      :return_rights,
      :consignment_basis,
      :credit_terms,
      :contact_email,
      :contact_id,
      :contact_status,
      :account_number,
      :tax_number,
      :addresses,
      :phones
    )
  end

  def create_new_attachment
    Attachments::AttachmentCreator.new(
      file_attributes: cloudinary_attribute_builder,
      resource: @debtor
    ).call
  end

  def cloudinary_attribute_builder
    Attachments::CloudinaryAttributeBuilder.new(params[:debtor]).call
  end
end
