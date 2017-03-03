require "rails_helper"

feature "Admin manages customers" do
  scenario "sees list of customers" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    user = create(:user, :seller, name: "John Smith")
    seller = user.seller
    create(:debtor,
           legal_business_name: "Test Ltd",
           seller: user.seller,
           seller_company: seller.seller_company)

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Customers"

    expect(page).to have_content "Test Ltd"
    expect(page).to have_content "John Smith"
  end

  scenario "views individual customer" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    seller = create(:seller)
    debtor = create(:debtor,
                    seller: seller,
                    legal_business_name: "Test Customer Name",
                    status: "pending")

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Customers"
    within(".debtor_#{debtor.id}") do
      click_link "View"
    end

    expect(page).to have_content "Test Customer Name"
    expect(page).to have_content "Pending"
    expect(page).to have_content seller.name
    expect(page).to have_content seller.seller_company_name
  end
end
