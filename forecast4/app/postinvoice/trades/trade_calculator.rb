module Trades
  class TradeCalculator
    def initialize(invoices:, seller:)
      @invoices = invoices
      @seller = seller
    end

    def total_face_value
      invoices.sum(:face_value)
    end

    def advance_amount
      invoices.inject(0.0) do |result, invoice|
        result += invoice.advance_amount_in_dollars
        result
      end
    end

    def discount_fee
      invoices.inject(0.0) do |result, invoice|
        result += invoice.discount_fee_in_dollars
        result
      end
    end

    def net_advance_amount
      advance_amount - seller_exchange_fee
    end

    def seller_exchange_fee
      seller.exchange_fee * total_face_value
    end

    def buyer_exchange_fee
      Preference.buyer_exchange_fee * total_face_value
    end

    private

    attr_reader :invoices, :seller
  end
end
