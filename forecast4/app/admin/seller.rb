ActiveAdmin.register Seller do
  form partial: 'form'

  actions :all, except: [:destroy]

  permit_params :name, :account_type, :email

  menu priority: 3

  filter :name
  filter :email
  filter :seller_company

  scope :all, default: true
  scope "New Sellers", :with_new_state
  scope "Business Registration", :with_business_registration_state
  scope "Customer Registration", :with_customer_registration_state
  scope "Terms Registration", :with_terms_registration_state
  scope "Completed", :with_completed_state

  index do
    id_column
    column :name
    column :email
    column :seller_company
    column "State", :workflow_state
    column :created_at

    actions

    column('Credit Reports') do |seller|
      link_to 'Upload Credit Reports', edit_admin_seller_path(seller)
    end

    if params[:scope] == "new_sellers"
      column('Update Registration Step') do |user|
        button_to 'Move to Next Step', admin_approve_seller_path(user),
          method: :patch
      end
    end
  end

  show title: :name do
    render "show", context: self
  end
end
