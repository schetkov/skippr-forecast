class CreateCustomerReceipts < ActiveRecord::Migration
  def change
    create_table :customer_receipts do |t|
      t.string :file_id
      t.string :file_name
      t.references :debtor

      t.timestamps
    end
  end
end
