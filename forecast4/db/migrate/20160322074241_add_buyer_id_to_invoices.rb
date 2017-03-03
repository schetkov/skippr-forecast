class AddBuyerIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :buyer_id, :integer
  end
end
