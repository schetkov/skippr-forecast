require 'rails_helper'

feature 'Admin sees companies in dashboard' do
  scenario 'visiting index page' do
    admin = create(:user, :admin, email: 'admin@example.com')
    create(:seller_company,
           name: 'Woolies Ltd',
           phone_number: '9876 5432',
           description: 'This is my business description')

    create(:user,
           name: 'John Smith',
           email: 'valid@example.com',
           account_type: "seller")

    visit admin_dashboard_path(as: admin)
    click_link 'Seller Companies'

    expect(page).to have_content 'Woolies Ltd'
    expect(page).to have_content 'John Smith'
    expect(page).to have_content '9876 5432'
    expect(page).to have_content 'This is my business description'
  end

  scenario 'visiting show page' do
    admin = create(:user, :admin, email: 'admin@example.com')
    company = create(:seller_company)

    visit admin_dashboard_path(as: admin)
    click_link 'Companies'
    within "#seller_company_#{company.id}" do
      click_link 'View'
    end

    expect(current_path).to eq admin_seller_company_path(company)
  end

  scenario 'editing a company' do
    admin = create(:user, :admin, email: 'admin@example.com')
    company = create(:seller_company)

    visit admin_dashboard_path(as: admin)
    click_link 'Seller Companies'
    within "#seller_company_#{company.id}" do
      click_link 'Edit'
    end
    fill_in 'Name', with: 'Colesy Ltd'
    fill_in 'Years in business', with: 3
    fill_in 'Address', with: '102 Macleay Street'
    fill_in 'Phone number', with: '9876 3232'
    fill_in 'Acn', with: 987654321
    # fill_in 'Groups revenues', with: 'Greater than $1 million'
    # fill_in 'Industry', with: 'Construction'
    # fill_in 'Debtors past due', with: 'between 10%-21%'
    # fill_in 'Largest debtor', with: '50%'
    # fill_in 'B2b sales', with: 'between 21%-50%'
    # fill_in 'Accounting software', with: 'MYOB'
    click_button 'Update Seller company'

    expect(page).to have_content 'Seller company was successfully updated.'
  end
end
