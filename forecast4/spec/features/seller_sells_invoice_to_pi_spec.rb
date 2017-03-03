require "rails_helper"

feature "Seller sells invoice via sell now feature to PI" do
  scenario "with approved invoices" do
    create(:preference, buyer_exchange_fee: 0.01)
    user = create(:user)
    buyer = create(:buyer, user: user)
    create(:buyer_company, name: "Peninsula Capital", buyer: buyer)
    seller = create(:seller, exchange_fee: 0.01)
    debtor = create(:debtor, :approved, seller: seller)
    invoice = create(:invoice,
                     :approved,
                     face_value: 10000,
                     seller: seller,
                     debtor: debtor,
                     date: Date.current,
                     anticipated_pay_date: Date.current + 45.days)
    other_invoice = create(:invoice,
                           :approved,
                           face_value: 20000,
                           seller: seller,
                           debtor: debtor,
                           date: Date.current,
                           anticipated_pay_date: Date.current + 30.days)
    invoice.rating.update(discount_rate: 0.10, advance_amount: 0.90)
    other_invoice.rating.update(discount_rate: 0.10, advance_amount: 0.90)

    visit seller_dashboard_path(as: seller.user)
    find(:css, "#invoice_#{invoice.id}").set(true)
    find(:css, "#invoice_#{other_invoice.id}").set(true)
    click_on "Create Trade"

    expect(page).to have_content invoice.invoice_no
    expect(page).to have_content other_invoice.invoice_no
    expect(page).to have_content "$10,000"
    expect(page).to have_content "$20,000"
    expect(page).to have_content debtor.legal_business_name

    within(".trade") do
      # Total Face Value
      expect(page).to have_content "$30,000"
      # Total Advance Amount
      expect(page).to have_content "$27,000"
      # Net Advance
      expect(page).to have_content "$26,700"
      # Discount Fee (Estimate based on anticipated pay date)
      expect(page).to have_content "$3,150"
      # Seller Exchange Fee
      expect(page).to have_content "$300"
    end

    click_button "Sell now"

    expect(page).to have_content "Your trade has been completed"
  end
end
