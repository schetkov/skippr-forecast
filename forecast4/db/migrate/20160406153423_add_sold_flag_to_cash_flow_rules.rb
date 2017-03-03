class AddSoldFlagToCashFlowRules < ActiveRecord::Migration
  def up
    add_column :cash_flow_rules, :is_sold, :boolean
  end
  
  def down
    remove_column :cash_flow_rules, :is_sold, :boolean
  end
end
