module Vendors
  class PayableAssignor
    def initialize(vendor)
      @vendor = vendor
    end

    def call
      if find_payable.present?
        find_payable.update_all(vendor_id: vendor.id)
      end
    end

    private

    attr_reader :vendor

    def find_payable
      Payable.where(invoice_contact_id: vendor.contact_id, vendor_id: nil)
    end
  end
end
