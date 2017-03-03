class CashFlowRule < ActiveRecord::Base

  belongs_to :cash_flow_scenario
  belongs_to :seller
  belongs_to :debtor
  belongs_to :vendor

  validates :amount, presence: true, numericality: true

  scope :receivables, -> { where(rule_type: 'sales') }
  scope :payables, -> { where('rule_type = ? OR rule_type = ?', "expenses", "other_expenses") }


  def to_json(options = {})
    options[:methods] = [:debtor] unless options[:methods]
    super(options)
  end

end
