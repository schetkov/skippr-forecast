class ChangeFinancialColumns < ActiveRecord::Migration
  def change
    rename_column :financials, :current_assets, :gross_profit_margin
    rename_column :financials, :total_assets, :last_reported_trade_debtors
    rename_column :financials, :current_liabilities, :last_reported_trade_creditors
    rename_column :financials, :total_liabilities, :loans_outstanding
    rename_column :financials, :retained_earnings, :liability_outstanding
  end
end
