ActiveAdmin.register Buyer do
  actions :all, except: [:edit, :destroy]

  menu priority: 4

  permit_params :name, :account_type, :email

  filter :name
  filter :email
  filter :company

  scope :all, default: true
  scope "New Buyers", :with_new_state
  scope "Confirmed", :with_confirmed_state
  scope "Completed", :with_completed_state
  scope "Approved", :with_approved_state

  index do
   id_column
    column('Name') { |buyer| buyer.name }
    column('Email') { |buyer| buyer.email }

    column :investor_type do |buyer|
      if buyer.investor_type.present?
        buyer.investor_type.capitalize
      else
        "-"
      end
    end
    column :created_at
    actions

    if params[:scope] == "new_buyers" || params[:scope] == "completed"
      column('Move to Next Step') do |user|
        button_to 'Move to Next Step', admin_approve_buyer_path(user),
          method: :patch
      end
    end
  end

  show title: :name do
    render "show", context: self
  end
end
