class FinancialsController < ApplicationController

  def update
    @financials = current_seller.seller_company.financials
    if @financials.update(financial_params)
      flash[:success] = 'Your financial information has been updated'
    else
      flash[:danger] = 'Sorry there was an error updating your financial information'
    end
    redirect_to :back
  end

  private

  def financial_params
    params.require(:financials).permit(
      :net_revenues,
      :gross_profit_margin,
      :last_reported_trade_debtors,
      :last_reported_trade_creditors,
      :loans_outstanding,
      :liability_outstanding
    )
  end
end
