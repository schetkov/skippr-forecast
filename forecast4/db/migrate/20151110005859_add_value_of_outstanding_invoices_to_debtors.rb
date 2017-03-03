class AddValueOfOutstandingInvoicesToDebtors < ActiveRecord::Migration
  def change
    add_column :debtors, :value_of_outstanding_invoices, :string
  end
end
