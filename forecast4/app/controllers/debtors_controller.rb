class DebtorsController < ApplicationController

  before_action :find_debtor, only: [:show, :edit, :destroy]

  def index
    @company = seller_company
  end

  def show
    @company = seller_company
    @attachment = Attachment.new
  end

  def new
    @debtor = Debtor.new
  end

  def create
    @debtor = current_seller.debtors.build(debtor_params)
    @debtor.seller_company = current_seller.seller_company
    create_new_attachment

    if @debtor.save
      flash[:success] = 'Thank you. Your Debtor is now pending'
      redirect_to debtors_path
      analytics.track_debtor_registration
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @debtor = current_seller.debtors.find_by(id: params[:id])

    if @debtor.update(debtor_params)
      create_new_attachment
      flash[:success] = 'You have successfully edited your Debtor.'
      redirect_to debtors_path
    else
      render 'edit'
    end
  end

  def destroy
    if @debtor.invoices.where('trade_id is not null').empty?
      @debtor.destroy
      flash[:success] = 'Your debtor has been deleted.'
    else
      flash[:danger] = 'Sorry you cannot delete this debtor because it has an invoice being used in a trade'
    end
    redirect_to debtors_path
  end

  private

  def find_debtor
    @debtor = current_seller.debtors.find_by(id: params[:id])
    if @debtor.nil?
      flash[:notice] = "You're not authorized to view that Debtor."
      redirect_to debtors_path
    end
  end

  def debtor_params
    params.require(:debtor).permit(
      :legal_business_name,
      :address,
      :acn,
      :website,
      :business_type,
      :business_sector,
      :contact_name,
      :contact_phone_number,
      :contact_email,
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
      :discounts_offered,
      :allow_offsets,
      :credit_terms,
      :relationship_start_date
    ).merge(relationship_start_date: relationship_start_date)
  end

  def relationship_start_date
    if params[:debtor][:relationship_start_date].present?
      Date.strptime(params[:debtor][:relationship_start_date], "%m/%d/%Y")
    end
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

  def seller_company
    current_seller.seller_company || NullCompany.new
  end
end
