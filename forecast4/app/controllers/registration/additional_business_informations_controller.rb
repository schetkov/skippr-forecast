class Registration::AdditionalBusinessInformationsController < ApplicationController
  respond_to :html

  layout 'registration'

  def create
    @registration = Registration::AdditionalBusinessInformation.new(registration_params)
    @registration.process(current_seller)
    flash_message if current_seller.awaiting_approval?
    respond_with @registration,
      location: registration_company_financial_information_path, action: 'show'
  end

  def show
    @registration = Registration::AdditionalBusinessInformation.new
  end

  private

  def registration_params
    params.require(:registration_additional_business_information).permit(
      :groups_revenues,
      :industry,
      :debtors_past_due,
      :largest_debtor,
      :b2b_sales,
      :accounting_software,
      :registration_step,
    )
  end

  def flash_message
    flash[:success] = 'Thank you. We have received your application.'
  end
end
