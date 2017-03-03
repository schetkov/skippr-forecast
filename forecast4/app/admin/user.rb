ActiveAdmin.register User do
  menu false

  index do
    id_column
    column :name
    column :email
    column :account_type
    column :company
    column :created_at
    actions
  end

  permit_params :name, :account_type, :email

  show do
    # TODO: Create a show builder
    attributes_table do
      row :id
      row :name
      row :email
      row :account
      row :account_type
      row :company
      row :drivers_license
      row :created_at
      row :updated_at
    end
  end
end
