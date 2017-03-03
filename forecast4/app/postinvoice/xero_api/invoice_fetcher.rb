module XeroApi
  class InvoiceFetcher
    def initialize(xero_client, seller)
      @xero_client = xero_client
      @seller = seller
      @total_invoices_count = get_invoices_count
      @invoices = []
    end

    def fetch
      xero_invoices.each do |invoice|
        begin
          find_existing_invoices(invoice).first_or_initialize.tap do |i|
            i.invoice_no = invoice.invoice_number
            i.face_value = invoice.total
            i.date = invoice.date
            i.due_date = invoice.due_date
            i.anticipated_pay_date = invoice.expected_payment_date || invoice.due_date
            i.invoice_xero_id = invoice.invoice_id
            i.invoice_contact_id = invoice.contact_id
            i.reference = invoice.reference
            i.xero_type = invoice.type
            i.xero_status = invoice.status
            i.total_tax = invoice.total_tax
            i.sub_total = invoice.sub_total
            i.amount_due = invoice.amount_due
            i.amount_paid = invoice.amount_paid
            i.amount_credited = invoice.amount_credited
            i.updated_date_utc = invoice.updated_date_utc
            i.currency_code = invoice.currency_code
            i.currency_rate = invoice.currency_rate
            #disabled cos of extra call to Xero API to get last payment
            #i.paid_on = invoice.payments.try(:last).try(:date)
            i.fully_paid_on_date = invoice.fully_paid_on_date
            i.seller_id = seller.id
            i.save!(:validate => false)
          end
        # rescue ActiveRecord::RecordInvalid
          # Should record this in the log
        end
      end
    end

    private

    attr_reader :xero_client, :seller

    def find_existing_invoices(invoice)
      seller.invoices.where(invoice_xero_id: invoice.invoice_id)
    end

    def get_invoices_count
      xero_client.Invoice.all(where: 'Type == "ACCREC" && (Status == "PAID" || Status == "AUTHORISED") && Status != "VOIDED"').count
    end

    def xero_invoices(page=1)
      @invoices +=
        xero_client.Invoice.all(page: page, where: 'Type == "ACCREC" && (Status == "PAID" || Status == "AUTHORISED") && Status != "VOIDED"')
        if @invoices.count < @total_invoices_count
          page = page + 1
          xero_invoices(page) 
        end
        return @invoices
    end
  end
end
