class ScenarioInvoice < ActiveRecord::Base

  belongs_to :scenario, class_name: CashFlowScenario, foreign_key: 'cash_flow_scenario_id'
  belongs_to :invoice

end
