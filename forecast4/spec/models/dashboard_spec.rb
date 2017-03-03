require "rails_helper"

describe Dashboard do
  describe "#trades" do
    it "returns trades for a given seller" do
      seller = create(:seller)
      trade = create(:trade, :confirmed, seller: seller)
      unconfirmed_trade = create(:trade, seller: seller)

      trades = Dashboard.new(seller).confirmed_trades

      expect(trades).to include trade
      expect(trades).not_to include unconfirmed_trade
    end
  end

  describe "#approved_invoices" do
    it "returns approved invoices for a given seller" do
      seller = create(:seller)
      approved_invoice = create(:invoice,
                                :active,
                                workflow_state: "approved",
                                seller: seller)
      pending_invoice = create(:invoice,
                               :active,
                               workflow_state: "pending",
                               seller: seller)
      other_invoice = create(:invoice)

      approved_invoices = Dashboard.new(seller).approved_invoices

      expect(approved_invoices).to include approved_invoice
      expect(approved_invoices).not_to include pending_invoice
      expect(approved_invoices).not_to include other_invoice
    end
  end

  describe "#pending_invoices" do
    it "returns pending invoices for a given seller" do
      seller = create(:seller)
      approved_invoice = create(:invoice,
                                :active,
                                workflow_state: "approved",
                                seller: seller)
      pending_invoice = create(:invoice,
                               :active,
                               workflow_state: "pending",
                               seller: seller)
      old_pending_invoice = create(:invoice,
                                   :active,
                                   due_date: (Date.current - 2.days),
                                   workflow_state: "pending",
                                   seller: seller)
      selected_invoice = create(:invoice,
                               :active,
                               workflow_state: "selected",
                               seller: seller)

      pending_invoices = Dashboard.new(seller).pending_invoices

      expect(pending_invoices).to include pending_invoice
      expect(pending_invoices).not_to include approved_invoice
      expect(pending_invoices).not_to include selected_invoice
      expect(pending_invoices).not_to include old_pending_invoice
    end
  end

  describe "#awaiting_approval" do
    it "returns pending invoices for a given seller" do
      seller = create(:seller)
      approved_invoice = create(:invoice,
                                :active,
                                workflow_state: "approved",
                                seller: seller)
      pending_invoice = create(:invoice,
                               :active,
                               workflow_state: "pending",
                               seller: seller)
      selected_invoice = create(:invoice,
                               :active,
                               workflow_state: "selected",
                               seller: seller)

      awaiting_approval_invoices = Dashboard.new(seller).awaiting_approval_invoices

      expect(awaiting_approval_invoices).to include selected_invoice
      expect(awaiting_approval_invoices).not_to include pending_invoice
      expect(awaiting_approval_invoices).not_to include approved_invoice
    end
  end
end
