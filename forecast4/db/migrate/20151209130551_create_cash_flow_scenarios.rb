class CreateCashFlowScenarios < ActiveRecord::Migration
  def change
    create_table :cash_flow_scenarios do |t|
      t.integer :seller_id
      t.string  :title
    end
  end
end
