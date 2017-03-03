module XeroApi
  class Authorizer
    def initialize(xero_record)
      @xero_record = xero_record
    end

    def authorize
      authorize_from_access_or_request_token
      update_access_tokens
      client
    end

    private

    attr_reader :xero_record

    def client
      @client ||= Xeroizer::PublicApplication.new(
        consumer_key,
        consumer_secret,
        rate_limit_sleep: 20,
        before_request: -> (request) { puts "Hitting this URL: #{request.url}" },
        after_request: -> (request, response) { puts "Got this response: #{response.code}" })
    end

    def authorize_from_access_or_request_token
      if no_token_or_more_than_15_minutes_old?
        authorize_from_request
      else
        authorize_from_access
      end
    end

    def no_token_or_more_than_15_minutes_old?
      xero_record.access_token_updated_at.nil? ||
         xero_record.access_token_updated_at < 15.minutes.ago
    end

    def authorize_from_access
      client.authorize_from_access(
        xero_record.access_token,
        xero_record.access_key
      )
    end

    def authorize_from_request
      # I think we should get a fresh request_token and secret here.
      client.authorize_from_request(
        xero_record.request_token,
        xero_record.request_secret,
        oauth_verifier: xero_record.oauth_verifier
      )
    end

    def update_access_tokens
      xero_record.update(
        access_token: access_token,
        access_key: access_key,
        access_token_updated_at: DateTime.now
      )
    end

    def access_token
      client.access_token.token
    end

    def access_key
      client.access_token.secret
    end

    def consumer_key
      ENV["XERO_CONSUMER_KEY"]
    end

    def consumer_secret
      ENV["XERO_CONSUMER_SECRET"]
    end
  end
end
