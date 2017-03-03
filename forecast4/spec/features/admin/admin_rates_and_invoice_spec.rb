require "rails_helper"

feature "Admin rates an invoice" do
  scenario "selected invoice which hasn't yet been rated" do
    create(:master_rating, discount_rate: 0.01, advance_amount: 0.8, rating_value: "1")
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    invoice = create(:invoice, :selected)

    visit custom_admin_invoice_path(invoice, as: admin)
    click_link "Apply Rating"
    select "1", from: "rating_master_rating_value"
    click_button "Apply Rating"

    expect(current_path).to eq custom_admin_invoice_path(invoice)
    within(".invoice-rating") do
      expect(page).to have_content "0.01" # Discount Rate
      expect(page).to have_content "0.8" # Advance Amount
      expect(page).to have_content "1" # Master Rating Value
    end
  end

  scenario "invoice without rating" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    invoice = create(:invoice, workflow_state: "selected")

    visit custom_admin_invoice_path(invoice, as: admin)

    expect(current_path).to eq custom_admin_invoice_path(invoice)
    within(".invoice-rating") do
      expect(page).to have_content "Invoice has not yet been rated."
    end
  end
end
