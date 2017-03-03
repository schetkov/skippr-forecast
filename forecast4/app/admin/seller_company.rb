ActiveAdmin.register SellerCompany do
  actions :all, except: [:destroy]

  menu priority: 1

  # scope :all
  # scope :awaiting_approval do |companies|
  #   companies.where('approved is null')
  # end
  # scope :approved do |companies|
  #   companies.where('approved is not null')
  # end

  index do
    id_column
    column :name
    column 'Contact Person', :user
    column :phone_number
    column :description
    actions
    # column('Approve') do |resource|
    #   if !resource.approved
    #     button_to 'Approve Company', admin_approve_company_path(resource), method: :patch
    #   else
    #     status_tag('Approved')
    #   end
    # end
  end

  show title: :name do
    render "show", context: self
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :years_in_business
      f.input :address
      f.input :phone_number
      f.input :website
      f.input :acn
      f.input :abn
      f.input :description
      f.input :principal_business_owner
      f.input :principal_ownership
      f.input :other_registered_name
      f.input :approved
      f.input :associated_institutions
      f.input :industry
      f.input :directors_name
      f.input :directors_email
      f.input :directors_address

      f.input :legal_name
      f.input :pays_tax
      f.input :version
      f.input :base_currency
      f.input :registration_number
      f.input :tax_number
      f.input :financial_year_end_day
      f.input :financial_year_end_month
      f.input :organisation_type
      f.input :short_code
      f.input :addresses, as: :text
      f.input :phones, as: :text
    end
    f.actions
  end

  permit_params :name, :years_in_business, :address, :phone_number, :website,
    :acn, :abn, :description, :principal_business_owner, :principal_ownership,
    :other_registered_name, :approved, :associated_institutions, :legal_name,
    :pays_tax, :version, :base_currency, :registration_number, :tax_number,
    :financial_year_end_day, :financial_year_end_month, :organisation_type,
    :short_code, :addresses, :phones, :directors_name, :directors_email,
    :directors_address
end
