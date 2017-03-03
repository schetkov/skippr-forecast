module XeroApi
  class VendorFetcher
    def initialize(xero_client, seller)
      @xero_client = xero_client
      @seller = seller
    end

    def fetch
      vendors.each do |vendor|
        find_existing_vendors(vendor).first_or_initialize.tap do |d|
          d.legal_business_name = vendor.name
          d.contact_id = vendor.contact_id
          d.contact_status = vendor.contact_status
          d.contact_email = vendor.email_address
          d.account_number = vendor.account_number
          d.tax_number = vendor.tax_number
          d.addresses = vendor.addresses
          d.phones = vendor.phones
          d.seller_id = seller.id
          d.seller_company_id = seller.seller_company.id
          d.save!

          Vendors::PayableAssignor.new(d).call
        end
      end
    end

    private

    attr_reader :xero_client, :seller

    def find_existing_vendors(vendor)
      seller.vendors.where(contact_id: vendor.contact_id)
    end

    def vendors
      xero_vendors.inject([]) do |result, vendor|
        if invoice_payable_ids.include?(vendor.contact_id)
          result << vendor
        end
        result
      end
    end

    def xero_vendors
      xero_client.Contact.all
    end

    def invoice_payable_ids
      seller.payables.pluck(:invoice_contact_id)
    end
  end
end
