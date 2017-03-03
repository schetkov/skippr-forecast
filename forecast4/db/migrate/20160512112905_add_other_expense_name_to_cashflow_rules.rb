class AddOtherExpenseNameToCashflowRules < ActiveRecord::Migration
  def up
    add_column :cash_flow_rules, :other_expenses_name, :string
  end

  def down
  	remove_column :cash_flow_rules, :other_expenses_name
  end
end
