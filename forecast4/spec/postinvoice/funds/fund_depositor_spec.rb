require "rails_helper"
describe Funds::FundDepositor do
  context "first time deposit" do
    describe "#call" do
      it "set the unallocated cash amount to the total cash amount/deposit" do
        buyer = create(:buyer)
        fund_statement_params = {
          buyer_id: "#{buyer.id}",
          total_cash: "100000"
        }

        fund_statement = Funds::FundDepositor.new(buyer, fund_statement_params).call

        expect(fund_statement.total_cash).to eq 100_000
        expect(fund_statement.unallocated_cash).to eq 100_000
        expect(fund_statement.allocated_cash).to eq 0
        expect(fund_statement.funds_deployed).to eq 0
      end
    end
  end
end
