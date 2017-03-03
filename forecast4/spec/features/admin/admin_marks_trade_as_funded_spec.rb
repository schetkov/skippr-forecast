require "rails_helper"

feature "Admin marks trade as funded" do
  scenario "trade has been 'sold' and admin is ready to fund" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    buyer = create(:buyer)
    # Deposit
    create(:fund_statement,
           buyer: buyer,
           total_cash: 100_000,
           allocated_cash: 8_500,
           unallocated_cash: 91_500)
    trade = create(:trade, :confirmed)
    create(:invoice, :sold, trade: trade, buyer: buyer)

    visit custom_admin_trade_path(trade, as: admin)
    click_button "Fund Trade"

    expect(current_path).to eq custom_admin_trade_path(trade)
    expect(page).to have_content "Invoices Funded"
    expect(trade.reload.funded_on).not_to eq nil
    expect(trade.invoices.last.funded?).to eq true
  end

  scenario "trade has already been funded" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    trade = create(:trade, :confirmed, funding_status: "Invoices Funded")

    visit custom_admin_trade_path(trade, as: admin)

    expect(page).not_to have_content "Fund Trade"
  end

  scenario "buyers moving balances gets updated after funding" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    buyer = create(:buyer)
    # Deposit
    create(:fund_statement,
           buyer: buyer,
           total_cash: 100_000,
           allocated_cash: 8_500,
           unallocated_cash: 91_500)

    trade = create(:trade, :confirmed)
    create(:invoice,
           :sold,
           buyer: buyer,
           trade: trade,
           face_value: 10_000)

    visit custom_admin_trade_path(trade, as: admin)
    click_button "Fund Trade"
    visit custom_admin_buyer_path(buyer)

    within(".funds_deployed_#{buyer.reload.latest_fund_statement.id}") do
      expect(page).to have_content "$8,500"
    end
    within(".allocated_cash_#{buyer.reload.latest_fund_statement.id}") do
      expect(page).to have_content "$0"
    end
  end
end
