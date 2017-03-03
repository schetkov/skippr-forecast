require "rails_helper"

feature "Admin marks invoice as repaid" do
  scenario "invoice has been funded and now paid in full" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    buyer = create(:buyer)
    # Deposit
    create(:fund_statement,
            buyer: buyer,
            total_cash: 91_500,
            funds_deployed: 8_500,
            unallocated_cash: 91_500)
    trade = create(:trade, funded_on: Date.current  - 30.days)
    invoice = create(:invoice, :funded, buyer: buyer, trade: trade)

    visit custom_admin_invoice_path(invoice, as: admin)
    click_button "Paid in Full"

    expect(current_path).to eq custom_admin_invoice_path(invoice)
    expect(page).to have_content "Paid in Full"
    expect(invoice.reload.paid_on).not_to eq nil
    expect(invoice.reload.repaid?).to eq true
  end

  scenario "invoice has been funded and now paid in short" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    buyer = create(:buyer)
    # Deposit
    create(:fund_statement,
            buyer: buyer,
            total_cash: 91_500,
            funds_deployed: 8_500,
            unallocated_cash: 91_500)
    trade = create(:trade, funded_on: Date.current  - 30.days)
    invoice = create(:invoice, :funded, buyer: buyer, trade: trade)

    visit custom_admin_invoice_path(invoice, as: admin)
    click_button "Paid in Short"

    expect(current_path).to eq custom_admin_invoice_path(invoice)
    expect(page).to have_content "Paid in Short"
    expect(invoice.reload.paid_on).not_to eq nil
    expect(invoice.reload.repaid?).to eq true
  end

  scenario "invoice is yet to be funded" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    invoice = create(:invoice, :sold)

    visit custom_admin_invoice_path(invoice, as: admin)

    expect(page).not_to have_content "Paid in Full"
    expect(page).not_to have_content "Paid in Short"
  end

  scenario "buyers moving balances gets updated after invoice gets repaid" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    buyer = create(:buyer)
    # Deposit
    create(:fund_statement,
            buyer: buyer,
            total_cash: 91_500,
            funds_deployed: 8_500,
            unallocated_cash: 91_500)
    trade = create(:trade, funded_on: Date.current  - 30.days)
    invoice = create(:invoice,
                     :funded,
                     buyer: buyer,
                     trade: trade,
                     paid_on: Date.current)

    visit custom_admin_invoice_path(invoice, as: admin)
    click_button "Paid in Full"
    visit custom_admin_buyer_path(buyer)

    within(".funds_deployed_#{buyer.reload.latest_fund_statement.id}") do
      expect(page).to have_content "$0"
    end
    within(".total_cash_#{buyer.reload.latest_fund_statement.id}") do
      expect(page).to have_content "$100,850"
    end
    within(".unallocated_cash_#{buyer.reload.latest_fund_statement.id}") do
      expect(page).to have_content "$100,850"
    end
  end
end
