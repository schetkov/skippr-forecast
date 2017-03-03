class AddVendorToCashFlowRule < ActiveRecord::Migration
  def change
    add_column :cash_flow_rules, :vendor_id, :integer
  end
end
