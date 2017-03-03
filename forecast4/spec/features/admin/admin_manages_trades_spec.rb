require "rails_helper"

feature "Admin manages trades" do
  scenario "sees list of trades" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    create(:trade,
           total_face_value: 10_000,
           advance_amount: 9_900,
           discount_fee: 50)

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Trades"

    expect(page).to have_content "$10,000"
    expect(page).to have_content "$9,900"
    expect(page).to have_content "$50"
  end

  scenario "views individual trade" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    trade = create(:trade,
                   :confirmed,
                   total_face_value: 10_000,
                   advance_amount: 9_900,
                   net_advance_amount: 9_790,
                   discount_fee: 50)

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Trades"
    within(".trade_#{trade.id}") do
      click_link "View"
    end

    expect(current_path).to eq custom_admin_trade_path(trade)
    expect(page).to have_content "$10,000"
    expect(page).to have_content "$9,900"
    expect(page).to have_content "$9,790"
    expect(page).to have_content "$50"
    expect(page).to have_content trade.confirmed_at.strftime("%b %e, %l:%M %p")
    expect(page).to have_content trade.seller.name
    expect(page).to have_content trade.created_at.strftime("%b %e, %l:%M %p")
    expect(page).to have_content trade.updated_at.strftime("%b %e, %l:%M %p")
  end

  scenario "sees individual trade with invoices" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    trade = create(:trade,
                   :confirmed,
                   total_face_value: 10_000,
                   advance_amount: 9_900,
                   net_advance_amount: 9_790,
                   discount_fee: 50)
    invoice = create(:invoice, face_value: 10_000, trade: trade)

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Trades"
    within(".trade_#{trade.id}") do
      click_link "View"
    end

    expect(page).to have_content invoice.id
    expect(page).to have_content "$10,000"
    expect(page).to have_content invoice.invoice_no
    expect(page).to have_content invoice.anticipated_pay_date.strftime("%d %B %Y")
  end
end
