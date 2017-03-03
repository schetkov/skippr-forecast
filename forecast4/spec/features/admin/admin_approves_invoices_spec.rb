require "rails_helper"

feature "Admin approves invoice" do
  scenario "selected invoice with a buyer who has enough unallocated funds" do
    admin = create(:user, :admin, email: "admin@example.com", password: "Foobar1234")
    debtor = create(:debtor)
    invoice = create(:invoice, :selected, face_value: 10_000, debtor: debtor)
    create(:rating, invoice: invoice, advance_amount: 0.01)
    buyer = create(:buyer)
    create(:fund_statement, buyer: buyer, unallocated_cash: 10_000)
    create(:mandate, debtor: debtor, buyer: buyer)

    visit custom_admin_invoice_path(invoice, as: admin)
    click_button "Approve"

    expect(page).to have_content "Approved"
  end

  scenario "with selected invoice but insufficient unallocated funds" do
    admin = create(:user, :admin, email: "admin@example.com", password: "Foobar1234")
    debtor = create(:debtor)
    invoice = create(:invoice, :selected, face_value: 10_000, debtor: debtor, buyer: nil)
    create(:rating, invoice: invoice, advance_amount: 0.8)
    buyer = create(:buyer)
    create(:fund_statement, buyer: buyer, unallocated_cash: 5_000)
    create(:mandate, debtor: debtor, buyer: buyer)

    visit custom_admin_invoice_path(invoice, as: admin)

    expect(page).not_to have_css "input[value='Approve Invoice']"
  end

  scenario "with pending invoice" do
    admin = create(:user, :admin, email: "admin@example.com", password: "Foobar1234")
    invoice = create(:invoice, workflow_state: "pending", face_value: 10_000)

    visit custom_admin_invoice_path(invoice, as: admin)

    expect(page).not_to have_css "input[value='Approve Invoice']"
  end
end
