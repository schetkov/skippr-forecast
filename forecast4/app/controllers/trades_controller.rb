class TradesController < ApplicationController
  def index
    @company = seller_company
    @trades = current_seller.trades.confirmed.order("created_at DESC")
  end

  def new
    @trade = Trades::TradeCreator.new(invoice_ids, current_seller).call
    analytics.track_trade_preview(invoice_ids)
  end

  def update
    @trade = current_seller.trades.where(id: params[:id]).first
    @trade.touch(:confirmed_at)
    @trade.invoices.map(&:sold!)
    redirect_to @trade
  end

  def show
    @trade = current_seller.trades.find_by(id: params[:id])
    if @trade.nil?
      flash[:notice] = "You are not authorized to view that trade."
      redirect_to trades_path
    end
  end

  private

  def invoice_ids
    params[:invoices]
  end

  def seller_company
    current_seller.seller_company || NullCompany.new
  end
end
