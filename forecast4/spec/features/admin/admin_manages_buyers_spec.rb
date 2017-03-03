require "rails_helper"

feature "Admin manages buyers" do
  scenario "sees list of buyers" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    buyer = create(:buyer)
    buyer.user.update(
      name: "Test Buyer",
      email: 'valid@example.com',
    )

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Buyers"

    expect(page).to have_content "Test Buyer"
    expect(page).to have_content "valid@example.com"
  end

  scenario "views individual buyer" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    buyer = create(:buyer)
    buyer.user.update(
      name: "Test Buyer",
      email: 'valid@example.com',
    )
    buyer.buyer_company.update(
      name: "Test Company Name",
      phone_number: "0444 123 321"
    )

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Buyers"
    click_link "Test Buyer"

    expect(page).to have_content "Test Buyer"
    expect(page).to have_content "valid@example.com"
    expect(page).to have_content "Test Company Name"
    expect(page).to have_content "0444 123 321"
  end

  scenario "creates new buyer with required attributes" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Buyers"
    click_link "Create Buyer"

    fill_in "Name", with: "Test Buyer"
    fill_in "Email", with: "valid@example.com"
    select "High Net Worth", from: "buyer_investor_type"
    fill_in "Company name", with: "Test Company Name"
    fill_in "Phone number", with: "1234 4567"
    fill_in "Password", with: "Passw0rd"
    click_button "Create Buyer"

    expect(page).to have_content "Test Buyer"
    expect(page).to have_content "valid@example.com"
    expect(page).to have_content "Test Company Name"
    expect(page).to have_content "High Net Worth"
    expect(page).to have_content "1234 4567"
  end

  scenario "creates new buyer with additional attributes" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Buyers"
    click_link "Create Buyer"

    fill_in "Name", with: "Test Buyer"
    fill_in "Email", with: "valid@example.com"
    select "High Net Worth", from: "buyer_investor_type"
    fill_in "Company name", with: "Test Company Name"
    fill_in "Phone number", with: "1234 4567"
    fill_in "Password", with: "Passw0rd"
    fill_in "ACN", with: "A123456"
    fill_in "ABN", with: "B654321"
    fill_in "Description", with: "Test Description"
    fill_in "AFSL Number", with: "A123"
    click_button "Create Buyer"

    expect(page).to have_content "Test Buyer"
    expect(page).to have_content "valid@example.com"
    expect(page).to have_content "Test Company Name"
    expect(page).to have_content "High Net Worth"
    expect(page).to have_content "1234 4567"
    expect(page).to have_content "A123456"
    expect(page).to have_content "B654321"
    expect(page).to have_content "Test Description"
    expect(page).to have_content "A123"
  end

  scenario "edits buyer with additional attributes" do
    buyer = create(:buyer)
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Buyers"
    within ".buyer_#{buyer.id}" do
      click_link "Edit"
    end

    fill_in "Name", with: "Test Buyer"
    fill_in "Email", with: "valid@example.com"
    select "High Net Worth", from: "buyer_investor_type"
    fill_in "Company name", with: "Test Company Name"
    fill_in "Phone number", with: "1234 4567"
    fill_in "Password", with: "Passw0rd"
    fill_in "ACN", with: "A123456"
    fill_in "ABN", with: "B654321"
    fill_in "Description", with: "Test Description"
    fill_in "AFSL Number", with: "A123"
    click_button "Update Buyer"

    expect(page).to have_content "Test Buyer"
    expect(page).to have_content "valid@example.com"
    expect(page).to have_content "Test Company Name"
    expect(page).to have_content "High Net Worth"
    expect(page).to have_content "1234 4567"
    expect(page).to have_content "A123456"
    expect(page).to have_content "B654321"
    expect(page).to have_content "Test Description"
    expect(page).to have_content "A123"
  end

  scenario "doesn't create new buyer without required attributes" do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')

    sign_in_with('admin@example.com', 'Foobar1234')
    click_link "Custom Admin"
    click_link "Buyers"
    click_link "Create Buyer"

    fill_in "Name", with: ""
    fill_in "Email", with: ""
    fill_in "Company name", with: ""
    fill_in "Password", with: "password"
    click_button "Create Buyer"

    expect(page).to have_content "User name can't be blank"
    expect(page).to have_content "User email can't be blank"
    expect(page).to have_content "Buyer company name can't be blank"
    expect(page).to have_content "User password must include at least one lowercase letter, one uppercase letter, and one digit."
  end
end
