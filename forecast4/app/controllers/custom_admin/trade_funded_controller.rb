class CustomAdmin::TradeFundedController < ApplicationController
  def create
    trade = Trade.find(params[:id])
    ActiveRecord::Base.transaction do
      trade.update(funding_status: "Invoices Funded", funded_on: Date.current)
      trade.invoices.map(&:funded!)
      Funds::FundDeployer.new(trade.invoices).call
    end

    flash[:success] = "The trade has been marked as funded"
    redirect_to custom_admin_trade_path(trade)
  end
end
