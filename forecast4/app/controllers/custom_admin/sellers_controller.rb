class CustomAdmin::SellersController < ApplicationController
  layout "admin"

  before_action :authenticate_admin_user!

  def index
    @sellers = Seller.order(created_at: :desc)
  end

  def show
    @seller = Seller.find(params[:id])
  end

  def new
    @seller = Seller.new
  end

  def create
    @seller = Seller.new(seller_params)
    @seller.workflow_state = "business_registration"
    if @seller.save
      redirect_to custom_admin_seller_path(@seller)
    else
      render "new"
    end
  end

  def edit
    @seller = Seller.find(params[:id])
  end

  def update
    @seller = Seller.find(params[:id])
    if @seller.update(seller_params)
      redirect_to custom_admin_seller_path(@seller)
    else
      render "edit"
    end
  end

  private

  def seller_params
    params.require(:seller).permit(
      :name,
      :email,
      :password,
      :exchange_fee,
      :is_cash_flow_user,
      :accepted_terms,
      :drivers_license_number,
      :dob,
      user_attributes: [
        :id,
        :account_type,
        :name,
        :email,
        :password
      ],
      seller_company_attributes: [
        :id,
        :name,
        :acn,
        :website,
        :phone_number,
        :years_in_business,
        :address,
        :abn,
        :description,
        :principal_business_owner,
        :principal_ownership,
        :other_registered_name,
        :industry,
        :associated_institutions,
        :directors_name,
        :directors_email,
        :directors_address
      ]
    )
  end
end
