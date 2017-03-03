require "rails_helper"

feature "Admin creates buyer mandates" do
  scenario "with valid attributes" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    buyer = create(:buyer)
    seller_company = create(:seller_company)
    create(:debtor, seller_company: seller_company, legal_business_name: "Woolies", status: "approved")

    sign_in_with('admin@example.com', 'Foobar1234')
    visit custom_admin_buyer_path(buyer, as: admin)
    click_link "Create Mandate"
    select "Woolies", from: "mandate_debtor_id"
    fill_in "% of funds for this investor", with: "100"
    fill_in "% of each invoice", with: "100"
    click_button "Save"

    expect(current_path).to eq custom_admin_buyer_path(buyer)
    expect(page).to have_content "Woolies"
    expect(page).to have_content "100"
  end
end
