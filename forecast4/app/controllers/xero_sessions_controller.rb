class XeroSessionsController < ApplicationController
  before_action :get_xero

  def new
    @xero.set_request_token
    redirect_to @xero.authorisation_url
  end

  def authorize_xero
    current_seller.update(workflow_state: 'completed') if current_seller.cash_flow_user?

    if current_seller.completed? && !current_seller.cash_flow_user?
      retrieve_data_from_xero
      flash[:success] = "Please refresh the page in a couple minutes as we pull your invoices from Xero"
      redirect_to seller_dashboard_path
    elsif current_seller.completed? && current_seller.cash_flow_user?
      retrieve_data_from_xero
      flash[:success] = "Please refresh the page in a couple minutes as we pull your invoices from Xero"
      redirect_to radar_invoices_path
    else
      retrieve_data_from_xero
      current_seller.register_customer!
      analytics.track_customer_registration_with_xero
      redirect_to terms_wizard_path
    end
  end

  private

  def get_xero
    if current_seller.xero_authorisations.any?
      @xero = current_seller.xero_authorisations.last
    else
      @xero = current_seller.xero_authorisations.build(host: host_with_port)
    end
  end

  def retrieve_data_from_xero
    @xero.update(oauth_verifier: xero_oauth_verifier)
    @xero.retrieve_data
  end

  def xero_oauth_verifier
    params[:oauth_verifier]
  end

  def host_with_port
    if Rails.env.test?
      "localhost:3000"
    else
      request.host_with_port
    end
  end
end
