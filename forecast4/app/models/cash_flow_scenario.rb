class CashFlowScenario < ActiveRecord::Base
  belongs_to :seller
  has_many :rules, class_name: CashFlowRule, :dependent => :destroy

  has_many :scenario_invoices
  has_many :invoices, through: :scenario_invoices
  has_many :scenario_payables
  has_many :payables, through: :scenario_payables

  validates :title, presence: true

  def invoices_with_settings(invoices)
    financials_data(invoices.as_json, self.scenario_invoices.as_json, :invoices)
  end

  def payables_with_settings(invoices)
    financials_data(invoices.as_json, self.scenario_payables.as_json, :payables)
  end

private

  # refactor this later
  def financials_data(fin_data, scenario_data, type)
    data_id = type == :invoices ? 'invoice_id' : 'payable_id'
    fin_data.each do |inv_hash|
      row = scenario_data.select{|sd| sd[data_id] == inv_hash['id']}
      if row.present?
          inv_hash['due_date'] = row[0]['due_date'] if type == :invoices
          inv_hash['anticipated_pay_date'] = row[0]['anticipated_pay_date']
          inv_hash['is_hidden'] = row[0]['is_hidden']
          inv_hash['is_sold'] = row[0]['is_sold'] if type == :invoices
        else
          inv_hash['is_hidden'] = false
          inv_hash['is_sold'] = false if type == :invoices
      end
    end
    return fin_data
  end

end
