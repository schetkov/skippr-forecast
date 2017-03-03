require "rails_helper"

describe FundStatementHelper do
  describe "#cash_earmarked" do
    it "should be same as advance amount if unallocated cash is greater" do
      fund_statement = create(:fund_statement, unallocated_cash: 100_000)
      invoice = create(:invoice, face_value: 20_000)
      create(:rating, advance_amount: 0.8, invoice: invoice)

      cash_earmarked = helper.cash_earmarked(fund_statement, invoice)

      expect(cash_earmarked).to eq 16_000
    end

    it "returns 0 if unallocated cash is insufficient" do
      fund_statement = create(:fund_statement, unallocated_cash: 1000)
      invoice = create(:invoice, face_value: 20_000)
      create(:rating, advance_amount: 0.8, invoice: invoice)

      cash_earmarked = helper.cash_earmarked(fund_statement, invoice)

      expect(cash_earmarked).to eq 0
    end
  end

  describe "#closing_unallocated_cash" do
    it "calculates difference between unallocated_cash and cash earmarked (invoice advance amount)" do
      fund_statement = create(:fund_statement, unallocated_cash: 100_000)
      invoice = create(:invoice, face_value: 20_000)
      create(:rating, advance_amount: 0.8, invoice: invoice)

      closing_unallocated_cash = helper.closing_unallocated_cash(fund_statement, invoice)

      expect(closing_unallocated_cash).to eq 84_000
    end

    it "returns 0 if unallocated_cash is insufficient" do
      fund_statement = create(:fund_statement, unallocated_cash: 1000)
      invoice = create(:invoice, face_value: 20_000)
      create(:rating, advance_amount: 0.8, invoice: invoice)

      closing_unallocated_cash = helper.closing_unallocated_cash(fund_statement, invoice)

      expect(closing_unallocated_cash).to eq 0
    end
  end
end
