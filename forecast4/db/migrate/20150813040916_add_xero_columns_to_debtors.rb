class AddXeroColumnsToDebtors < ActiveRecord::Migration
  def change
    add_column :debtors, :contact_id, :string
    add_column :debtors, :contact_status, :string
    add_column :debtors, :account_number, :string
    add_column :debtors, :tax_number, :string
    add_column :debtors, :addresses, :json
    add_column :debtors, :phones, :json
  end
end
