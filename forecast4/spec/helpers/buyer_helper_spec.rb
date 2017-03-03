require "rails_helper"

describe BuyerHelper do
  describe "#buyer_has_sufficient_funds?" do
    it "returns true if buyers last fund statement has more unallocated cash than invoice advance amount" do
      buyer = create(:buyer)
      create(:fund_statement, unallocated_cash: 10_000, buyer: buyer)
      invoice = create(:invoice, :selected, face_value: 10_000)

      sufficient_funds = helper.buyer_has_sufficient_funds?(buyer, invoice)

      expect(sufficient_funds).to eq true
    end

    it "returns false if buyer has insufficient funds" do
      buyer = create(:buyer)
      create(:fund_statement, unallocated_cash: 5_000, buyer: buyer)
      invoice = create(:invoice, :selected, face_value: 10_000)

      sufficient_funds = helper.buyer_has_sufficient_funds?(buyer, invoice)

      expect(sufficient_funds).to eq false
    end
  end

  describe "#buyers_allocated_cash_for_debtor" do
    it "aggregates advance amounts for approved and sold invoices" do
      buyer = create(:buyer)
      debtor = create(:debtor)
      create(:invoice, :approved, buyer: buyer, debtor: debtor)
      create(:invoice, workflow_state: "pending", buyer: buyer, debtor: debtor)

      allocated_cash = helper.buyers_allocated_cash_for_debtor(buyer, debtor)

      expect(allocated_cash).to eq 8_500
    end
  end

  describe "#buyers_funds_deployed_for_debtor" do
    it "aggregates advance amounts for funded invoices" do
      buyer = create(:buyer)
      debtor = create(:debtor)
      create(:invoice, :funded, buyer: buyer, debtor: debtor)
      create(:invoice, workflow_state: "pending", buyer: buyer, debtor: debtor)

      funds_deployed = helper.buyers_funds_deployed_for_debtor(buyer, debtor)

      expect(funds_deployed).to eq 8_500
    end
  end

  describe "#bueyrs_current_exposure_for_debtor" do
    context "with no funds deployed" do
      it "adds allocated cash and funds deployed to calculate current exposure" do
        buyer = create(:buyer)
        debtor = create(:debtor)
        create(:invoice, :approved, buyer: buyer, debtor: debtor)
        create(:invoice, workflow_state: "pending", buyer: buyer, debtor: debtor)

        current_exposure = helper.buyers_current_exposure_for_debtor(buyer, debtor)

        expect(current_exposure).to eq 8_500
      end
    end

    context "with cash allocated and funds deployed" do
      it "adds allocated cash and funds deployed to calculate current exposure" do
        buyer = create(:buyer)
        debtor = create(:debtor)
        create(:invoice, :approved, buyer: buyer, debtor: debtor)
        create(:invoice, :funded, buyer: buyer, debtor: debtor)

        current_exposure = helper.buyers_current_exposure_for_debtor(buyer, debtor)

        expect(current_exposure).to eq 17_000
      end
    end
  end
end
