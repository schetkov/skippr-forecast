require "rails_helper"

describe XeroSessionsController do
  describe "#new" do
    it "requests token from Xero API and redirects to the authorization url" do
      seller = create(:seller)
      create(:xero_authorisation, seller: seller)
      sign_in(seller.user)
      request_token = double("request_token_response",
                             authorize_url: "http://some-url.com",
                             token: "123",
                             secret: "321")
      allow_any_instance_of(XeroAuthorisation).to receive(:request_token_response).
        and_return(request_token)
      expect_any_instance_of(XeroAuthorisation).to receive(:request_token_response)

      get :new

      expect(subject).to redirect_to request_token.authorize_url
    end
  end

  describe "#authorize_xero" do
    it "authorizes and saves access tokens from xero" do
      seller = create(:seller, workflow_state: "customer_registration")
      xero_authorisation = create(:xero_authorisation, seller: seller)
      sign_in(seller.user)
      allow(XeroDataRetrieverJob).to receive(:perform_later).
        with(xero_id: xero_authorisation.id, seller_id: seller.id)

      get "authorize_xero", oauth_verifier: "12345"

      expect(xero_authorisation.reload.oauth_verifier).to eq "12345"
      expect(XeroDataRetrieverJob).to have_received(:perform_later).
        with(xero_id: xero_authorisation.id, seller_id: seller.id)
      expect(seller.reload.workflow_state).to eq "terms_registration"
    end
  end
end
