require "rails_helper"

describe Funds::BuyerFundDeployer do
  describe "#call" do
    it "moves funds from allocated to funds deployed" do
      buyer = create(:buyer)
      # Deposit
      create(:fund_statement,
             buyer: buyer,
             total_cash: 100_000,
             allocated_cash: 8_500,
             unallocated_cash: 91_500)
      invoice = create(:invoice,
                       :approved,
                       buyer: buyer,
                       face_value: 10_000)

      Funds::BuyerFundDeployer.new(invoice).call

      expect(buyer.latest_fund_statement.reload.total_cash).to eq 91_500
      expect(buyer.latest_fund_statement.reload.allocated_cash).to eq 0
      expect(buyer.latest_fund_statement.reload.unallocated_cash).to eq 91_500
      expect(buyer.latest_fund_statement.reload.funds_deployed).to eq 8_500
      expect(buyer.latest_fund_statement.reload.note).to eq(
        "$8500 deployed for invoice ##{invoice.id}")
    end
  end
end
