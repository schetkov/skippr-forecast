context.instance_eval do
  attributes_table do
    row :id
    row :name
    row :email
    row :dob
    row :accounting_platform
    row :workflow_state
    row :terms_accepted_at do |seller|
      if seller.is_authorised_officer
        "True"
      else
        "False"
      end
    end
    row :is_authorised_officer
    row :seller_company
    row :drivers_license do |seller|
      if seller.drivers_license.present?
        link_to "View Driver's License",
          cl_image_path(seller.drivers_license.file_name),
          target: '_blank'
      end
    end
    row :created_at
    row :updated_at
    row('Trades') do |seller|
      link_to 'View Trades', admin_trades_path(q: "[seller_id_eq]=#{seller.id}")
    end
    row('Invoices') do |seller|
      link_to 'View Invoices', admin_invoices_path(q: "[seller_id_eq]=#{seller.id}")
    end
    row('Debtors') do |seller|
      link_to 'View Debtors', admin_debtors_path(q: "[seller_id_eq]=#{seller.id}")
    end
  end

  if seller.seller_company.existing_facilities.present?
    render "admin/existing_facilities/index",
      existing_facilities: seller.seller_company.existing_facilities, context: self
  end

  render "admin/invoice_documents/index",
    invoice_documents: seller.seller_company.invoice_documents, context: self if seller.seller_company

  render "admin/financial_statements/index",
    financial_statements: seller.seller_company.financial_statements, context: self if seller.seller_company

  render "admin/bank_statements/index",
    bank_statements: seller.seller_company.bank_statements, context: self if seller.seller_company

  render "admin/other_supporting_documents/index",
    misc_documents: seller.seller_company.misc_documents, context: self if seller.seller_company

  render "admin/bank_details/index",
    bank_details: seller.seller_company.bank_details, context: self if seller.seller_company.bank_details

  render "admin/debtor_terms/index",
    debtor_terms: seller.seller_company.debtor_terms, context: self if seller.seller_company.debtor_terms

  render "admin/seller_credit_reports/index",
    credit_reports: seller.credit_reports, context: self
end
