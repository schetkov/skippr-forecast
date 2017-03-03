context.instance_eval do
  attributes_table do
    row :rating_value
    row :seller
    row :debtor
    row :invoice_no
    row :face_value
    row("State") do |instance|
      instance.workflow_state
    end
    row :purchase_order_number
    row :description
    row :discounts_offered
    row :date
    row :due_date
    row :anticipated_pay_date
    row :funding_status do |instance|
      if instance.trade
        instance.trade.funding_status
      end
    end
    row :service_rendered
    row :customer_satisfied
    row :payment_to_be_sent
    row :created_at
    row :updated_at
    row('Funding Status Notes') do |instance|
      instance.admin_funding_status_notes
    end
    row('Invoice Funded On') do |instance|
      if instance.trade && instance.trade.funded_on
        instance.trade.funded_on.strftime('%B %d, %Y')
      end
    end
    row('Invoice Payment Status') do |instance|
      instance.payment_status
    end
    row :amount_paid_by_debtor
    row('Invoice Paid On') do |instance|
      instance.paid_on.strftime('%B %d, %Y') if instance.paid_on
    end
    row('Admin Notes') do |instance|
      instance.admin_general_notes
    end

    row :invoice_xero_id
    row :invoice_contact_id
    row :reference
    row :xero_type
    row :xero_status
    row :total_tax
    row :sub_total
    row :amount_due
    row :amount_paid
    row :amount_credited
    row :updated_date_utc
    row :currency_code
    row :currency_rate
    row :fully_paid_on_date
  end

  render "admin/invoices/rating/show", invoice: invoice,
    context: self if invoice
  render "admin/invoices/fees/show", invoice: invoice,
    context: self if invoice
  render "admin/invoices/proof_of_work/show", invoice: invoice,
    context: self if invoice
  render "admin/invoices/attachments/index", invoices: invoice.attachments,
    context: self if invoice.attachments
  render "admin/ppsr/index", invoices: invoice.ppsrs,
    context: self if invoice.ppsrs
  render "admin/notice_of_assignment/index", invoices: invoice.notice_of_assignments,
    context: self if invoice.notice_of_assignments
  render "admin/invoice_document/index", invoices: invoice.invoice_document,
    context: self if invoice.invoice_document
  render "admin/purchase_order_files/index", invoices: invoice.purchase_order_files,
    context: self if invoice.purchase_order_files
end
