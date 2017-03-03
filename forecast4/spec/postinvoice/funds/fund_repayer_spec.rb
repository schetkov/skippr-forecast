require "rails_helper"

describe Funds::FundRepayer do
  describe "#call" do
    it "updates funds from funds deployed to unallocated" do
      buyer = create(:buyer)
      # Deposit
      create(:fund_statement,
             buyer: buyer,
             total_cash: 91_500,
             funds_deployed: 8_500,
             allocated_cash: 0,
             unallocated_cash: 91_500)
      trade = create(:trade, funded_on: (Date.current - 30.days))
      invoice = create(:invoice,
                       :funded,
                       buyer: buyer,
                       trade: trade,
                       paid_on: Date.current,
                       face_value: 10_000)

      Funds::FundRepayer.new(invoice).call

      expect(buyer.latest_fund_statement.reload.total_cash).to eq 100_850
      expect(buyer.latest_fund_statement.reload.allocated_cash).to eq 0
      expect(buyer.latest_fund_statement.reload.unallocated_cash).to eq 100_850
      expect(buyer.latest_fund_statement.reload.funds_deployed).to eq 0
      expect(buyer.latest_fund_statement.reload.note).to eq(
        "$9350 repaid for invoice ##{invoice.id}")
    end
  end
end

