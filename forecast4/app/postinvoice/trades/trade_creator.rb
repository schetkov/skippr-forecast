module Trades
  class TradeCreator

    def initialize(invoice_ids, seller)
      @seller = seller
      @invoices = seller.invoices.where(id: invoice_ids)
      @trade_calculator = Trades::TradeCalculator.new(
        invoices: invoices,
        seller: seller
      )
    end

    def call
      trade = seller.trades.create(
        total_face_value: trade_calculator.total_face_value,
        advance_amount: trade_calculator.advance_amount,
        net_advance_amount: trade_calculator.net_advance_amount,
        discount_fee: trade_calculator.discount_fee,
        seller_exchange_fee: trade_calculator.seller_exchange_fee,
        buyer_exchange_fee: trade_calculator.buyer_exchange_fee,
      )

      trade.invoices << invoices
      trade
    end

    private

    attr_reader :seller, :invoices, :trade_calculator
  end
end
