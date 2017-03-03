class XeroAuthorisation < ActiveRecord::Base

  CONSUMER_KEY = ENV["XERO_CONSUMER_KEY"]
  CONSUMER_SECRET = ENV["XERO_CONSUMER_SECRET"]

  belongs_to :seller

  def set_request_token
    self.request_token = request_token_response.token
    self.request_secret = request_token_response.secret
    self.save
  end

  def authorisation_url
    request_token_response.authorize_url
  end

  def retrieve_data
    XeroDataRetrieverJob.perform_later(xero_id: id, seller_id: seller.id)
  end

  private

  def client
    @client ||= Xeroizer::PublicApplication.new(CONSUMER_KEY,
                                                CONSUMER_SECRET,
                                                rate_limit_sleep: 10)
  end

  def request_token_response
    @request_token_response ||=
      client.request_token(oauth_callback: callback_url)
  end

  def callback_url
    "http://#{host}/xero_session"
  end
end
