class AddFundingStatusNotesToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :admin_funding_status_notes, :text
  end
end
