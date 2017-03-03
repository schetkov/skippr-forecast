class Registration::BusinessRegistrationsController < ApplicationController
  layout "registration"

  before_action :check_if_user_is_coming_from_wizard
  before_action :redirect_user

  def new
    @business_registration = Registration::BusinessRegistrar.new
  end

  def create
    @business_registration = Registration::BusinessRegistrar.new(registration_params).call
    if @business_registration.valid?
      seller = current_user.seller.reload
      seller.business_registered!
      analytics.track_business_registration

      if seller.xero_user?
        redirect_to new_xero_path
      else
        redirect_to customer_wizard_path
      end
    else
      render "new"
    end
  end

  private

  def registration_params
    # Explicity setting whitelisted params because of form object & fields_for
    params.require(:registration_business_registrar).permit(:accounting_platform).tap do |whitelisted|
      whitelisted[:seller_id] = current_seller.id
      whitelisted[:existing_facility] = params[:registration_business_registrar][:existing_facility]
      whitelisted[:financial_statements] = params[:registration_business_registrar][:financial_statement]
      whitelisted[:bank_statements] = params[:registration_business_registrar][:bank_statement]
      whitelisted[:other_supporting_documents] = params[:registration_business_registrar][:other_supporting_documents]
    end
  end

  def check_if_user_is_coming_from_wizard
    if http_referer_is_from_wizard?
      current_seller.update(workflow_state: "business_registration")
    end
  end

  def http_referer_is_from_wizard?
    http_referer && http_referer.include?("wizard")
  end

  def http_referer
    request.env["HTTP_REFERER"]
  end

  def redirect_user
    if !current_seller.business_registration?
      url = Sessions::SessionRedirector.new(current_user).call
      redirect_to url
    end
  end
end
