require "rails_helper"

feature "Admin allocates funds to an invoice" do
  scenario "selected invoice with sufficient unallocated funds" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    debtor = create(:debtor)
    buyer = create(:buyer)
    create(:fund_statement, total_cash: 10_000, unallocated_cash: 10_000, buyer: buyer)
    create(:mandate, buyer: buyer, debtor: debtor)
    invoice = create(:invoice, :selected, face_value: 10_000, debtor: debtor, buyer: nil)

    visit custom_admin_invoice_path(invoice, as: admin)
    click_button "Allocate"

    expect(page).to have_content buyer.name
    expect(invoice.reload.buyer).to eq buyer
  end

  scenario "buyers moving balances gets updated after allocation" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    debtor = create(:debtor)
    buyer = create(:buyer)
    create(:fund_statement, total_cash: 10_000, unallocated_cash: 10_000, buyer: buyer)
    create(:mandate, buyer: buyer, debtor: debtor)
    invoice = create(:invoice, :selected, face_value: 10_000, debtor: debtor, buyer: nil)

    visit custom_admin_invoice_path(invoice, as: admin)
    click_button "Allocate"
    visit custom_admin_buyer_path(buyer)

    within(".allocated_cash_#{buyer.reload.latest_fund_statement.id}") do
      expect(page).to have_content "$8,500"
    end
    within(".unallocated_cash_#{buyer.reload.latest_fund_statement.id}") do
      expect(page).to have_content "$1,500"
    end
  end
end
