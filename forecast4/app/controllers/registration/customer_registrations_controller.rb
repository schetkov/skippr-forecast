class Registration::CustomerRegistrationsController < ApplicationController
  layout "registration"

  before_action :redirect_user

  def new
    @customer_registration = Registration::CustomerRegistrar.new
  end

  def create
    Registration::CustomerRegistrar.new(registration_params).call
    current_seller.customer_registered!
    analytics.track_customer_registration

    redirect_to terms_wizard_path
  end

  private

  def registration_params
    {
      seller_id: current_seller.id,
      debtors: params[:registration_customer_registrar][:debtor],
      invoice_documents: params[:registration_customer_registrar][:invoice_documents]
    }
  end

  def redirect_user
    if !current_seller.customer_registration?
      url = Sessions::SessionRedirector.new(current_user).call
      redirect_to url
    end
  end
end
