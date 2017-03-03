class CreateCashFlowRules < ActiveRecord::Migration
  def change
    create_table :cash_flow_rules do |t|
      t.integer  :cash_flow_scenario_id
      t.integer  :seller_id
      t.integer  :debtor_id
      t.string   :rule_type
      t.string   :reference
      t.decimal  :amount, precision: 10, scale: 2
      t.string   :currency_code
      t.integer  :interval, default: 1
      t.integer  :terms
      t.datetime :due_date
    end
  end
end
