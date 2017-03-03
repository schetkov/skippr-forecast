module XeroApi
  class DataRetriever
    def initialize(xero_record, seller)
      @xero_record = xero_record
      @seller = seller
    end

    def call
      XeroApi::OrganisationFetcher.new(xero_client, seller).fetch
      XeroApi::InvoiceFetcher.new(xero_client, seller).fetch
      XeroApi::PayableFetcher.new(xero_client, seller).fetch
      XeroApi::DebtorFetcher.new(xero_client, seller).fetch
      XeroApi::VendorFetcher.new(xero_client, seller).fetch
      XeroApi::BankDetailsFetcher.new(xero_client, seller).fetch
    # rescue ActiveRecord::RecordInvalid => exception
    #   if exception.message.include? "Short code"
    #     seller.touch(:error_importing_from_xero)
    #   end
    end

    private

    attr_reader :xero_record, :seller

    def xero_client
      @xero_client ||= XeroApi::Authorizer.new(xero_record).authorize
    end
  end
end
