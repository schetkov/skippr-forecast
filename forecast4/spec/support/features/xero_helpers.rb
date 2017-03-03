module Features
  module XeroHelpers
    def stub_xero_authorisation_request_token_response
      request_token = double("request_token_response",
                            authorize_url: xero_session_path,
                            token: "123",
                            secret: "321")
      allow_any_instance_of(XeroAuthorisation).to receive(:request_token_response).
        and_return(request_token)
    end
  end
end
