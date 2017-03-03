require "rails_helper"

describe Trades::TradeCreator do
  describe "#call" do
    it "creates a trade given a set of invoice ids" do
      create(:preference, seller_exchange_fee: 0.01, buyer_exchange_fee: 0.01)
      seller = create(:seller, exchange_fee: 0.01)
      debtor = create(:debtor, :approved, seller: seller)
      invoice = create(:invoice,
                       :approved,
                       face_value: 10000,
                       seller: seller,
                       debtor: debtor,
                       date: Date.current,
                       anticipated_pay_date: Date.current + 45.days)
      other_invoice = create(:invoice,
                             :approved,
                             face_value: 20000,
                             seller: seller,
                             debtor: debtor,
                             date: Date.current,
                             anticipated_pay_date: Date.current + 30.days)

      invoice_ids = Invoice.all.map(&:id)
      trade = Trades::TradeCreator.new(invoice_ids, seller).call

      expect(trade.invoices).to include invoice
      expect(trade.invoices).to include other_invoice
      expect(trade.total_face_value).to eq 30000
      expect(trade.advance_amount).to eq 25500
      expect(trade.net_advance_amount).to eq 25200
      expect(trade.discount_fee).to eq 2975
      expect(trade.seller_exchange_fee).to eq 300
      expect(trade.buyer_exchange_fee).to eq 300
    end
  end
end
