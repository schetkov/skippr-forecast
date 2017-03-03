class Registration::TermsRegistrationsController < ApplicationController
  layout "registration"

  def new
    @terms_registration = Registration::TermsRegistrar.new
  end

  def create
    @terms_registration = Registration::TermsRegistrar.new(terms_params).call
    if @terms_registration.valid?
      current_seller.terms_registered!
      Esignature::Esignor.new(directors_params).request_signature
      analytics.track_terms_registration

      if current_seller.cash_flow_user?
        redirect_to radar_invoices_path
      else
        redirect_to seller_dashboard_path
      end
    else
      render "new"
    end
  end

  private

  def terms_params
    params.require(:registration_terms_registrar).permit(
      :directors_name,
      :directors_address,
      :directors_email,
      :drivers_license_number,
      :dob_day,
      :dob_month,
      :dob_year,
    ).merge(seller_id: current_seller.id)
  end

  def directors_params
    {
      name: params[:registration_terms_registrar][:directors_name],
      email: params[:registration_terms_registrar][:directors_email]
    }
  end
end
