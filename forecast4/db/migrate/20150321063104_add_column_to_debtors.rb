class AddColumnToDebtors < ActiveRecord::Migration
  def change
    add_column :debtors, :discounts_offered, :string
  end
end
