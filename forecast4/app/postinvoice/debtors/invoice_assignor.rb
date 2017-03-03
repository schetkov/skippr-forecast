module Debtors
  class InvoiceAssignor
    def initialize(debtor)
      @debtor = debtor
    end

    def call
      if find_invoice.present?
        find_invoice.update_all(debtor_id: debtor.id)
      end
    end

    private

    attr_reader :debtor

    def find_invoice
      Invoice.where(invoice_contact_id: debtor.contact_id, debtor_id: nil)
    end
  end
end
