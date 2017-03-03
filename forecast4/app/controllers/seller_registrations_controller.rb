class SellerRegistrationsController < ApplicationController
  respond_to :html

  def create
    @registration = Registration::SellerRegistrar.new(registration_params)
    @registration.call(current_seller)

    respond_with @registration,
      location: seller_dashboard_path, action: 'show'
  end

  private

  def registration_params
    params.require(:registration_seller_registrar).permit(
      :name,
      :acn,
      :years_in_business,
      :address,
      :phone_number,
      :website,
      :industry,
      :other_registered_name,
      :bank_account_name,
      :bank_account_number,
      :bsb_number
    ).merge!(existing_facility_params)
  end

  def existing_facility_params
    { existing_facility: params[:registration_seller_registrar][:existing_facility] }
  end
end
