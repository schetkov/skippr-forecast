require "rails_helper"

feature "Admin manages invoices" do
  scenario "sees list of invoices" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    debtor = create(:debtor, legal_business_name: "Test Ltd")
    invoice = create(:invoice,
                     invoice_no: "INV-001",
                     face_value: 10_000,
                     workflow_state: "pending",
                     debtor: debtor)
    create(:rating, master_rating_value: "1", invoice: invoice)

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Invoices"

    expect(page).to have_content "INV-001"
    expect(page).to have_content "Test Ltd"
    expect(page).to have_content "$10,000"
    expect(page).to have_content "1"
    expect(page).to have_content "Pending"
  end

  scenario "views individual invoice" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    seller = create(:seller)
    seller.user.update(name: "Ralph Wintle")
    trade = create(:trade,
                   funding_status: "Invoice Funded",
                   funded_on: Date.current)
    invoice = create(:invoice,
                     trade: trade,
                     seller: seller,
                     invoice_no: "INV-001",
                     purchase_order_number: "123",
                     discounts_offered: "yes",
                     date: Date.new(2016, 02, 03),
                     due_date: Date.new(2016, 03, 30),
                     anticipated_pay_date: Date.new(2016, 03, 31),
                     rating_value: "1",
                     workflow_state: "approved",
                     face_value: 100_000,
                     payment_status: "Outstanding",
                     paid_on: Date.current,
                     amount_paid_by_debtor: "$80000")

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Invoices"
    within(".invoice_#{invoice.id}") do
      click_link "View"
    end

    # FUNDS DEPLOYED / TRADE FUNDED
    expect(page).to have_content "Invoice Funded" # Trade's funding status
    expect(page).to have_content invoice.trade.funded_on.strftime("%b %e, %l:%M %p")

    # INVOICE PAID BY DEBTOR
    expect(page).to have_content "Outstanding" # payment_status
    expect(page).to have_content invoice.paid_on.strftime("%b %e, %l:%M %p") # date invoice was paid by debtor
    expect(page).to have_content "$80000" # amount_paid_by_debtor - usually advance amount

    expect(page).to have_content "Approved" # Status
    expect(page).to have_content "1" # Rating value
    expect(page).to have_content "Ralph Wintle" # Seller name
    expect(page).to have_content "INV-001" # Invoice No
    expect(page).to have_content "$100,000" # Face Value
    expect(page).to have_content "123" # Purchase Order No
    expect(page).to have_content "Yes"
    expect(page).to have_content "03 February 2016" # Date
    expect(page).to have_content "30 March 2016" # Due Date
    expect(page).to have_content "31 March 2016" # Due Date
    expect(page).to have_content invoice.created_at.strftime("%b %e, %l:%M %p")
    expect(page).to have_content invoice.updated_at.strftime("%b %e, %l:%M %p")
  end

  scenario "views invoice with list of buyers who want to buy it" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    debtor = create(:debtor)
    invoice = create(:invoice, :selected, debtor: debtor, buyer: nil)
    user = create(:user, :buyer)
    create(:mandate, debtor: debtor, percentage_of_funds_for_investor: 100, buyer: user.buyer)
    create(:fund_statement,
           buyer: user.buyer,
           total_cash: 118_000,
           unallocated_cash: 100_000,
           allocated_cash: 18_000)


    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Invoices"
    within(".invoice_#{invoice.id}") do
      click_link "View"
    end

    expect(page).to have_content "John Smith"
    expect(page).to have_content "$118,000" # Total Cash (unallocated + allocated)
    expect(page).to have_content "$100,000" # unallocated_cash amount
    expect(page).to have_content "100%" # % allocation (set in mandate)
    expect(page).to have_content "$8,500" # allocated_cash amount
    expect(page).to have_content "$91,500" # closed_unallocated_cash
  end
end
