require 'rails_helper'

feature 'Admin approves company' do
  # scenario 'where user is a seller' do
  #   ENV['ADMIN_EMAILS'] = 'admin@example.com'
  #   create(:user, email: 'admin@example.com', password: 'password')
  #   create(:user, email: 'valid@example.com', password: 'password')
  #   sign_in_with('valid@example.com', 'password')

  #   fill_in 'Contact Name', with: 'John Smith'
  #   fill_in 'Business Name', with: 'Woolies Ltd'
  #   fill_in 'Years in Business', with: 5
  #   fill_in 'Business Address', with: '101 Macleay Street, Potts Point, NSW, 2011'
  #   fill_in 'Business Phone Number', with: '9123 4567'
  #   fill_in 'Business Website', with: 'http://www.woolies.com'
  #   fill_in 'ACN', with: 123456789
  #   fill_in 'Business Description', with: 'This is a description of my amazing business.'
  #   click_button 'Submit'

  #   select 'greater than $1 million', from: 'registration_step_two_groups_revenues'
  #   select 'Retail', from: 'registration_step_two_industry'
  #   select 'between 0-10%', from: 'registration_step_two_debtors_past_due'
  #   fill_in 'registration_step_two_largest_debtor', with: '25%'
  #   select 'between 0-20%', from: 'registration_step_two_b2b_sales'
  #   fill_in 'registration_step_two_accounting_software', with: 'Quickbooks. About two years'
  #   click_button 'Submit'
  #   click_link 'Sign out'

  #   sign_in_with('admin@example.com', 'password')

  #   company = Company.last

  #   click_link 'Companies'
  #   within "#company_#{company.id}" do
  #     click_button 'Approve Company'
  #   end

  #   company.reload

  #   expect(page).to have_content 'Woolies Ltd has been approved.'
  #   expect(company.approved?).to be_true
  # end
end
