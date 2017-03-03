class AddAgedReceivablesLastUpdatedAtToDebtors < ActiveRecord::Migration
  def change
    add_column :debtors, :aged_receivables_last_updated_at, :datetime
  end
end
