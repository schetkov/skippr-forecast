class AddColumnsToScenarioPayableTable < ActiveRecord::Migration
  def change
    add_column :scenario_payables, :anticipated_pay_date, :date
  end
end
