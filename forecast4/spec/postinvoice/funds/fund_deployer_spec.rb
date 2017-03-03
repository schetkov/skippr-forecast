require "rails_helper"

describe Funds::FundDeployer do
  describe "#call" do
    it "creates a new fund statement and updates funds deployed column for all buyers" do
      first_buyer = create(:buyer)
      # Deposit
      create(:fund_statement,
             buyer: first_buyer,
             total_cash: 100_000,
             allocated_cash: 8_500,
             unallocated_cash: 91_500)
      second_buyer = create(:buyer)
      # Deposit
      create(:fund_statement,
             buyer: second_buyer,
             total_cash: 100_000,
             allocated_cash: 17_000,
             unallocated_cash: 83_000)

      trade = create(:trade)
      first_invoice = create(:invoice,
                             :approved,
                             buyer: first_buyer,
                             trade: trade,
                             face_value: 10_000)
      second_invoice = create(:invoice,
                              :approved,
                              buyer: second_buyer,
                              trade: trade,
                              face_value: 20_000)

      fake_fund_deployer = double("fund deployer", call: true)
      allow(Funds::BuyerFundDeployer).to receive(:new).with(first_invoice).and_return(fake_fund_deployer)
      allow(Funds::BuyerFundDeployer).to receive(:new).with(second_invoice).and_return(fake_fund_deployer)

      Funds::FundDeployer.new(trade.invoices).call

      expect(Funds::BuyerFundDeployer).to have_received(:new).with(first_invoice)
      expect(Funds::BuyerFundDeployer).to have_received(:new).with(second_invoice)
    end
  end
end
