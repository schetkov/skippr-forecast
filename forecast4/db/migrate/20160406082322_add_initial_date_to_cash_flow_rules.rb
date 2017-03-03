class AddInitialDateToCashFlowRules < ActiveRecord::Migration
  def up
    add_column :cash_flow_rules, :initial_date, :datetime
  end
  
  def down
    remove_column :cash_flow_rules, :initial_date, :datetime
  end
end
