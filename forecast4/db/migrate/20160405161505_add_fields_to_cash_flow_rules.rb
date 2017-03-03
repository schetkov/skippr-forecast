class AddFieldsToCashFlowRules < ActiveRecord::Migration
  def up
    add_column :cash_flow_rules, :is_clone, :boolean
    add_column :cash_flow_rules, :is_hidden, :boolean
    add_column :cash_flow_rules, :parent_id, :integer
  end
  
  def down
    remove_column :cash_flow_rules, :is_clone, :boolean
    remove_column :cash_flow_rules, :is_hidden, :boolean
    remove_column :cash_flow_rules, :parent_id, :integer
  end
end
