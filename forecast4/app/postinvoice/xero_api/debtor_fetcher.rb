module XeroApi
  class DebtorFetcher
    def initialize(xero_client, seller)
      @xero_client = xero_client
      @seller = seller
    end

    def fetch
      debtors.each do |debtor|
        find_existing_debtors(debtor).first_or_initialize.tap do |d|
          d.legal_business_name = debtor.name
          d.contact_id = debtor.contact_id
          d.contact_status = debtor.contact_status
          d.contact_email = debtor.email_address
          d.account_number = debtor.account_number
          d.tax_number = debtor.tax_number
          d.addresses = debtor.addresses
          d.phones = debtor.phones
          d.seller_id = seller.id
          d.seller_company_id = seller.seller_company.id
          d.save!

          Debtors::InvoiceAssignor.new(d).call
          Debtors::AgedReceivablesCalculator.new(xero_client, d).call
        end
      end
    end

    private

    attr_reader :xero_client, :seller

    def find_existing_debtors(debtor)
      seller.debtors.where(contact_id: debtor.contact_id)
    end

    def debtors
      xero_debtors.inject([]) do |result, debtor|
        if invoice_contact_ids.include?(debtor.contact_id)
          result << debtor
        end
        result
      end
    end

    def xero_debtors
      xero_client.Contact.all
    end

    def invoice_contact_ids
      seller.invoices.pluck(:invoice_contact_id)
    end
  end
end
