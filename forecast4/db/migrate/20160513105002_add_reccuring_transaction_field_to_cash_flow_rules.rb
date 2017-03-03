class AddReccuringTransactionFieldToCashFlowRules < ActiveRecord::Migration
  def change
    add_column :cash_flow_rules, :reccuring, :bool
  end
end
