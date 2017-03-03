class CastCashFlowRulesTimestampsToDate < ActiveRecord::Migration
  def change
    change_column :cash_flow_rules, :initial_date, 'date USING CAST(initial_date AS date)'
    change_column :cash_flow_rules, :due_date, 'date USING CAST(due_date AS date)'
  end
end
