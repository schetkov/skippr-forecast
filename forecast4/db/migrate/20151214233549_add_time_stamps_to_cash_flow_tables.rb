class AddTimeStampsToCashFlowTables < ActiveRecord::Migration
  def change
    change_table :cash_flow_scenarios do |t|
      t.timestamps
    end

    change_table :cash_flow_rules do |t|
      t.timestamps
    end
  end
end
