class AddXeroColumnsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_xero_id, :string
    add_column :invoices, :invoice_contact_id, :string
    add_column :invoices, :reference, :string
    add_column :invoices, :xero_type, :string
    add_column :invoices, :xero_status, :string
    add_column :invoices, :total_tax, :decimal
    add_column :invoices, :sub_total, :decimal
    add_column :invoices, :amount_due, :decimal
    add_column :invoices, :amount_paid, :decimal
    add_column :invoices, :amount_credited, :decimal
    add_column :invoices, :updated_date_utc, :datetime
    add_column :invoices, :currency_code, :string
    add_column :invoices, :currency_rate, :decimal
    add_column :invoices, :fully_paid_on_date, :datetime
    remove_column :invoices, :company_id, :integer
    change_column :invoices, :face_value, :decimal, default: 0.00
  end
end
