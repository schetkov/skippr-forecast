class CreatePayablesScenariosTable < ActiveRecord::Migration
  def change
    create_table :scenario_payables do |t|
      t.belongs_to :payable, index: true
      t.belongs_to :cash_flow_scenario, index: true
      t.boolean :is_hidden
    end
  end
end
