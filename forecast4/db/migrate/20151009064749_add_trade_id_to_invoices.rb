class AddTradeIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :trade_id, :integer
  end
end
