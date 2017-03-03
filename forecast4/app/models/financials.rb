class Financials < ActiveRecord::Base
  belongs_to :seller_company

  validates :net_revenues,
            :gross_profit_margin,
            :last_reported_trade_debtors,
            :last_reported_trade_creditors,
            :loans_outstanding,
            :liability_outstanding, presence: true
end
