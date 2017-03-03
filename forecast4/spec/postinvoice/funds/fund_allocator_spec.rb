require "rails_helper"

describe Funds::FundAllocator do
  describe "#call" do
    it "creates a new fund statement and moves unallocated cash to allocated cash" do
      buyer = create(:buyer)
      create(:fund_statement,
            buyer: buyer,
            total_cash: 100_000,
            funds_deployed: 100,
            unallocated_cash: 100_000)
      invoice = create(:invoice, :approved, face_value: 10_000)

      Funds::FundAllocator.new(buyer, invoice).call

      expect(buyer.latest_fund_statement.total_cash).to eq 100_000 # all cash - funds deployed
      expect(buyer.latest_fund_statement.allocated_cash).to eq 8_500
      expect(buyer.latest_fund_statement.unallocated_cash).to eq 91_500
      expect(buyer.latest_fund_statement.funds_deployed).to eq 100
      expect(buyer.latest_fund_statement.note).to eq "$8500 allocated to invoice ##{invoice.id}"
    end
  end
end
