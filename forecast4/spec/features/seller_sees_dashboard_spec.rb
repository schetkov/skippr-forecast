require "rails_helper"

describe "Seller sees dashboard" do
  scenario "with confirmed trades" do
    seller = create(:seller)
    trade = create(:trade,
                   confirmed_at: Date.current,
                   total_face_value: 10000,
                   advance_amount: 9000,
                   discount_fee: 1000,
                   seller: seller)
    create(:invoice, :approved, trade: trade)

    visit seller_dashboard_path(seller, as: seller.user)

    within ".trade_#{trade.id}" do
      expect(page).to have_content trade.confirmed_at.strftime("%d %B")
      expect(page).to have_content "$10,000"
      expect(page).to have_content "$9,000"
      expect(page).to have_content "$1,000"
    end
  end

  scenario "with unconfirmed trades" do
    seller = create(:seller)
    trade = create(:trade,
                   confirmed_at: nil,
                   total_face_value: 10000,
                   advance_amount: 9000,
                   discount_fee: 1000,
                   seller: seller)
    create(:invoice, :approved, trade: trade)

    visit seller_dashboard_path(seller, as: seller.user)

    expect(page).not_to have_content "$10,000"
    expect(page).not_to have_content "$9,000"
    expect(page).not_to have_content "$1,000"
  end

  scenario "with approved and pending invoices" do
    seller = create(:seller)
    approved_invoice = create(:invoice,
                              :active,
                              face_value: 10000,
                              invoice_no: 12345,
                              workflow_state: "approved",
                              seller: seller)
    awaiting_approval_invoice = create(:invoice,
                              :active,
                              face_value: 10000,
                              invoice_no: 66666,
                              workflow_state: "selected",
                              seller: seller)
    pending_invoice = create(:invoice,
                             :active,
                             face_value: 20000,
                             invoice_no: 54321,
                             workflow_state: "pending",
                             seller: seller)
    create(:invoice, :expired, workflow_state: "approved", seller: seller)
    create(:invoice, :expired, workflow_state: "pending", seller: seller)

    visit seller_dashboard_path(seller, as: seller.user)

    within ".invoice_#{approved_invoice.id}" do
      expect(page).to have_content approved_invoice.date.strftime("%e %b %Y")
      expect(page).to have_content "$10,000"
      expect(page).to have_content "12345"
      expect(page).to have_content approved_invoice.debtor.legal_business_name
    end

    within ".invoice_#{awaiting_approval_invoice.id}" do
      expect(page).to have_content awaiting_approval_invoice.date.strftime("%e %b %Y")
      expect(page).to have_content "$10,000"
      expect(page).to have_content "66666"
      expect(page).to have_content awaiting_approval_invoice.debtor.legal_business_name
    end

    within ".invoice_#{pending_invoice.id}" do
      expect(page).to have_content pending_invoice.date.strftime("%e %b %Y")
      expect(page).to have_content "$20,000"
      expect(page).to have_content "54321"
      expect(page).to have_content pending_invoice.debtor.legal_business_name
    end
  end
end
