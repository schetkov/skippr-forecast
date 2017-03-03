ActiveAdmin.register Debtor do
  form partial: 'form'

  menu priority: 5

  filter :legal_business_name
  filter :contact_name
  filter :seller

  scope :pending
  scope :approved

  index do
    id_column
    column :legal_business_name
    column('User') do |debtor|
      link_to debtor.seller_name, admin_user_path(debtor.seller.user)
    end
    column('Company') do |debtor|
      link_to debtor.seller_company_name, admin_seller_company_path(debtor.seller_company)
    end
    column('Status') do |debtor|
      if debtor.pending?
        button_to 'Approve Debtor', admin_approve_debtor_path(debtor),
          method: :patch
      else
        'Approved'
      end
    end
    actions
  end

  show title: :id do
    render "show", context: self
  end

  permit_params :legal_business_name,
                :address,
                :acn,
                :website,
                :business_type,
                :business_sector,
                :contact_name,
                :contact_phone_number,
                :internal_account_debtor_id,
                :customer_reference_id,
                :payment_processor,
                :other_name,
                :thirty_days,
                :sixty_days,
                :ninety_days,
                :over_ninety_days,
                :warranties,
                :progressive_billing,
                :return_rights,
                :consignment_basis,
                :credit_terms,
                :relationship_start_date,
                :status,
                :seller_id,
                :seller_company_id,
                :discounts_offered,
                :allow_offsets,
                :contact_email,
                :contact_id,
                :contact_status,
                :account_number,
                :tax_number,
                :addresses,
                :phones,
                :aged_receivables_last_updated_at,
                :value_of_outstanding_invoices

end
