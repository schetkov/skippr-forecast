class AddColumnsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :payment_status, :string, default: 'Outstanding'
    add_column :invoices, :amount_paid_by_debtor, :string
    add_column :invoices, :paid_on, :date
    add_column :invoices, :funded_on, :date
    add_column :invoices, :admin_general_notes, :text
  end
end
