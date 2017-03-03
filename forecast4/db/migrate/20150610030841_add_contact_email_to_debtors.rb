class AddContactEmailToDebtors < ActiveRecord::Migration
  def change
    add_column :debtors, :contact_email, :string
  end
end
