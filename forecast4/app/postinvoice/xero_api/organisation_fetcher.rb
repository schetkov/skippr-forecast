module XeroApi
  class OrganisationFetcher
    def initialize(xero_client, seller)
      @xero_client = xero_client
      @seller = seller
    end

    def fetch
      if seller.seller_company
        seller.seller_company.tap do |c|
          c.name = organisation.name
          c.legal_name = organisation.legal_name
          c.pays_tax = organisation.pays_tax
          c.version = organisation.version
          c.base_currency = organisation.base_currency
          c.registration_number = organisation.registration_number
          c.tax_number = organisation.tax_number
          c.financial_year_end_day = organisation.financial_year_end_day
          c.financial_year_end_month = organisation.financial_year_end_month
          c.organisation_type = organisation.organisation_type
          c.short_code = organisation.short_code
          c.addresses = organisation.addresses
          c.phones = organisation.phones
          c.save!
        end
      end
    end

    private

    attr_reader :xero_client, :seller

    def organisation
      @organisation ||= xero_client.Organisation.all.first
    end
  end
end
