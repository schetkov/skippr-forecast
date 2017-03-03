class AddVendorFieldToPayableTable < ActiveRecord::Migration
  def change
    add_column :payables, :vendor_id, :integer
  end
end
