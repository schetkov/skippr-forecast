require "rails_helper"

feature "Admin manages sellers" do
  scenario "sees list of sellers" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    seller = create(:seller)
    seller.user.update(
      name: "Test Seller",
      email: 'valid@example.com',
    )

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Sellers"

    expect(page).to have_content "Test Seller"
    expect(page).to have_content "valid@example.com"
  end

  scenario "views individual seller" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    seller = create(:seller)
    seller.user.update(
      name: "Test Seller",
      email: 'valid@example.com',
    )
    seller.seller_company.update(
      name: "Test Company Name",
      phone_number: "0444 123 321"
    )

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Sellers"
    click_link "Test Seller"

    expect(page).to have_content "Test Seller"
    expect(page).to have_content "valid@example.com"
    expect(page).to have_content "Test Company Name"
    expect(page).to have_content "0444 123 321"
  end

  scenario "views individual seller with invoices" do
    admin = create(:user, :admin)
    seller = create(:seller)
    create(:invoice, invoice_no: "INV-001", seller: seller)

    visit custom_admin_seller_path(seller, as: admin)
    find(:css, ".seller-invoices").click

    expect(page).to have_content "INV-001"
  end

  scenario "creates new seller with required attributes" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Sellers"
    click_link "Create Seller"

    fill_in "Name", with: "Test Seller"
    fill_in "Email", with: "valid@example.com"
    fill_in "Company name", with: "Test Company Name"
    fill_in "ACN", with: "123456"
    fill_in "Website", with: "www.website.com"
    fill_in "Phone number", with: "1234 4567"
    fill_in "Exchange Fee", with: 0.01
    fill_in "Password", with: "Passw0rd"
    click_button "Create Seller"

    expect(page).to have_content "Test Seller"
    expect(page).to have_content "valid@example.com"
    expect(page).to have_content "Test Company Name"
    expect(page).to have_content "123456"
    expect(page).to have_content "www.website.com"
    expect(page).to have_content "1.0%"
    expect(page).to have_content "1234 4567"
  end

  scenario "creates new seller with additional attributes" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Sellers"
    click_link "Create Seller"

    fill_in "Name", with: "Test Seller"
    fill_in "Email", with: "valid@example.com"
    fill_in "Company name", with: "Test Company Name"
    fill_in "ACN", with: "123456"
    fill_in "Website", with: "www.website.com"
    fill_in "Phone number", with: "1234 4567"
    fill_in "Exchange Fee", with: 0.01
    fill_in "Password", with: "Passw0rd"

    # Seller related stuff
    fill_in "Drivers license number", with: "ABC123"
    select "2", from: "seller_dob_3i"
    select "December", from: "seller_dob_2i"
    select "1980", from: "seller_dob_1i"

    # SellerCompany related stuff
    fill_in "Years in business", with: "2"
    fill_in "Address", with: "101 Address"
    fill_in "ABN", with: "12345"
    fill_in "Description", with: "Test Description"
    fill_in "Principal business owner", with: "Principal Owner"
    fill_in "Principal ownership", with: "90%"
    fill_in "Other registered name", with: "N/A"
    select "Construction", from: "seller_seller_company_attributes_industry"
    fill_in "Associated institutions", with: "Associated Institution"
    fill_in "Directors name", with: "Test Director"
    fill_in "Directors email", with: "Director Email"
    fill_in "Directors address", with: "Director Address"

    click_button "Create Seller"

    expect(page).to have_content "ABC123"
    expect(page).to have_content "2 December 1980"
    expect(page).to have_content "101 Address"
    expect(page).to have_content "12345"
    expect(page).to have_content "Test Description"
    expect(page).to have_content "Principal Owner"
    expect(page).to have_content "90%"
    expect(page).to have_content "N/A"
    expect(page).to have_content "Construction"
    expect(page).to have_content "Associated Institution"
    expect(page).to have_content "Test Director"
    expect(page).to have_content "Director Email"
    expect(page).to have_content "Director Address"
  end

  scenario "edits seller" do
    seller = create(:seller)
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Sellers"
    within ".seller_#{seller.id}" do
      click_link "Edit"
    end

    fill_in "Name", with: "Test Seller"
    fill_in "Email", with: "valid@example.com"
    fill_in "Company name", with: "Test Company Name"
    fill_in "ACN", with: "123456"
    fill_in "Website", with: "www.website.com"
    fill_in "Phone number", with: "1234 4567"
    fill_in "Exchange Fee", with: 0.05
    fill_in "Password", with: "Passw0rd"

    # Seller related stuff
    find(:css, "#seller_accepted_terms_true").set(true)
    fill_in "Drivers license number", with: "ABC123"
    select "2", from: "seller_dob_3i"
    select "December", from: "seller_dob_2i"
    select "1980", from: "seller_dob_1i"

    # SellerCompany related stuff
    fill_in "Years in business", with: "2"
    fill_in "Address", with: "101 Address"
    fill_in "ABN", with: "12345"
    fill_in "Description", with: "Test Description"
    fill_in "Principal business owner", with: "Principal Owner"
    fill_in "Principal ownership", with: "90%"
    fill_in "Other registered name", with: "N/A"
    select "Construction", from: "seller_seller_company_attributes_industry"
    fill_in "Associated institutions", with: "Associated Institution"
    fill_in "Directors name", with: "Test Director"
    fill_in "Directors email", with: "Director Email"
    fill_in "Directors address", with: "Director Address"

    click_button "Update Seller"

    expect(page).to have_content "Test Seller"
    expect(page).to have_content "valid@example.com"
    expect(page).to have_content "Test Company Name"
    expect(page).to have_content "123456"
    expect(page).to have_content "www.website.com"
    expect(page).to have_content "5.0%"
    expect(page).to have_content "1234 4567"
    expect(page).to have_content "ABC123"
    expect(page).to have_content "2 December 1980"
    expect(page).to have_content "101 Address"
    expect(page).to have_content "12345"
    expect(page).to have_content "Test Description"
    expect(page).to have_content "Principal Owner"
    expect(page).to have_content "90%"
    expect(page).to have_content "N/A"
    expect(page).to have_content "Construction"
    expect(page).to have_content "Associated Institution"
    expect(page).to have_content "Test Director"
    expect(page).to have_content "Director Email"
    expect(page).to have_content "Director Address"
  end

  scenario "doesn't create new seller without required attributes" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Sellers"
    click_link "Create Seller"

    fill_in "Name", with: ""
    fill_in "Email", with: ""
    fill_in "Company name", with: ""
    fill_in "ACN", with: ""
    fill_in "Website", with: ""
    fill_in "Phone number", with: ""
    fill_in "Exchange Fee", with: ""
    fill_in "Password", with: "password"
    click_button "Create Seller"

    expect(page).to have_content "User name can't be blank"
    expect(page).to have_content "User email can't be blank"
    expect(page).to have_content "Seller company name can't be blank"
    expect(page).to have_content "Exchange fee can't be blank"
    expect(page).to have_content "User password must include at least one lowercase letter, one uppercase letter, and one digit."
  end
end
