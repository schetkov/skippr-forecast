require "rails_helper"

feature "Admin deposits funds into buyers account" do
  scenario "first time deposit" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    buyer = create(:buyer)

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Buyers"
    click_link "View"
    click_link "Deposit Funds"
    fill_in "Amount", with: 100_000
    click_button "Deposit Funds"

    expect(current_path).to eq custom_admin_buyer_path(buyer)
    expect(page).to have_content "$100,000"
  end
end
