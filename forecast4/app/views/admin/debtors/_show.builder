context.instance_eval do
  attributes_table do
    row :seller
    row :seller_company
    row :legal_business_name
    row :address
    row :phone_number
    row :acn
    row :website
    row :business_type
    row :business_sector
    row :contact_name
    row :contact_phone_number
    row :internal_account_debtor_id
    row :payment_processor
    row :other_name
    row :thirty_days
    row :sixty_days
    row :ninety_days
    row :over_ninety_days
    row :warranties
    row :progressive_billing
    row :return_rights
    row :consignment_basis
    row :credit_terms
    row :relationship_start_date
    row :status
    row :created_at
    row :updated_at
    row :discounts_offered
    row :allow_offsets
    row :contact_email
    row :contact_id
    row :contact_status
    row :account_number
    row :tax_number
    row :addresses
    row :phones
  end

  render "admin/credit_reports/index",
    invoices: debtor.credit_reports,
    context: self if debtor.credit_reports
  render "admin/sales_agreements/index",
    invoices: debtor.sales_agreements,
    context: self if debtor.sales_agreements
  render "admin/customer_receipts/index",
    invoices: debtor.customer_receipts,
    context: self if debtor.customer_receipts
end
