module XeroApi
  class BankDetailsFetcher
    def initialize(xero_client, seller)
      @xero_client = xero_client
      @seller_company = seller.seller_company
    end

    def fetch
      if account
        seller_company.build_bank_details.tap do |bank_details|
          bank_details.account_name = account.name
          bank_details.account_number = account_number
          bank_details.bsb_number = bsb_number
          bank_details.save!
        end
      end
    end

    private

    attr_reader :xero_client, :seller_company

    def account
      @account ||= xero_client.Account.all(where: 'Type=="BANK"').first
    end

    def account_number
      account.bank_account_number[6..-1]
    end

    def bsb_number
      account.bank_account_number[0..5]
    end
  end
end
