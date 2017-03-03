require "rails_helper"

describe Trades::TradeCalculator do
  describe "#total_face_value" do
    it "calculates the sum face value for a collection of invoices" do
      seller = create(:seller)
      create(:invoice, face_value: 10_000, seller: seller)
      create(:invoice, face_value: 10_000, seller: seller)

      trade_calculator = Trades::TradeCalculator.new(
        invoices: seller.invoices,
        seller: seller
      )

      expect(trade_calculator.total_face_value).to eq 20_000
    end
  end

  describe "#advance_amount" do
    it "calculates the sum advance amount for a collection of invoices" do
      seller = create(:seller)
      invoice = create(:invoice, face_value: 10_000, seller: seller)
      other_invoice = create(:invoice, face_value: 10_000, seller: seller)
      create(:rating, advance_amount: 0.9, invoice: invoice)
      create(:rating, advance_amount: 0.9, invoice: other_invoice)

      trade_calculator = Trades::TradeCalculator.new(
        invoices: seller.invoices,
        seller: seller
      )

      expect(trade_calculator.advance_amount).to eq 18_000
    end
  end

  describe "#net_advance_amount" do
    it "calculates the advance amount minus seller exchange fee" do
      create(:preference, seller_exchange_fee: 0.01)
      seller = create(:seller)
      invoice = create(:invoice, face_value: 10_000, seller: seller)
      other_invoice = create(:invoice, face_value: 10_000, seller: seller)
      create(:rating, advance_amount: 0.9, invoice: invoice)
      create(:rating, advance_amount: 0.9, invoice: other_invoice)

      trade_calculator = Trades::TradeCalculator.new(
        invoices: seller.invoices,
        seller: seller
      )

      expect(trade_calculator.net_advance_amount).to eq 17_800
    end
  end

  describe "#discount_fee" do
    it "calculates the sum discount fee for a collection of invoices" do
      seller = create(:seller)
      invoice = create(:invoice,
                       face_value: 10_000,
                       date: Date.current,
                       anticipated_pay_date: Date.current + 30.days,
                       seller: seller)
      other_invoice = create(:invoice,
                             face_value: 10_000,
                             date: Date.current,
                             anticipated_pay_date: Date.current + 30.days,
                             seller: seller)
      create(:rating,
             advance_amount: 0.9,
             discount_rate: 0.1,
             invoice: invoice)
      create(:rating,
             advance_amount: 0.9,
             discount_rate: 0.1,
             invoice: other_invoice)

      trade_calculator = Trades::TradeCalculator.new(
        invoices: seller.invoices,
        seller: seller
      )

      expect(trade_calculator.discount_fee).to eq 1_800
    end
  end

  describe "#seller_exchange_fee" do
    it "multiplies the exchange fee with the total face value" do
      seller = create(:seller, exchange_fee: 0.01)
      create(:invoice, face_value: 10_000, seller: seller)
      create(:invoice, face_value: 10_000, seller: seller)

      trade_calculator = Trades::TradeCalculator.new(
        invoices: seller.invoices,
        seller: seller
      )

      expect(trade_calculator.seller_exchange_fee).to eq 200
    end
  end

  describe "#buyer_exchange_fee" do
    it "multiplies the exchange fee with the total face value" do
      create(:preference, buyer_exchange_fee: 0.01)
      seller = create(:seller)
      create(:invoice, face_value: 10_000, seller: seller)
      create(:invoice, face_value: 10_000, seller: seller)

      trade_calculator = Trades::TradeCalculator.new(
        invoices: seller.invoices,
        seller: seller
      )

      expect(trade_calculator.buyer_exchange_fee).to eq 200
    end
  end
end
