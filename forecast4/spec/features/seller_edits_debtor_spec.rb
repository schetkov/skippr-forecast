require 'rails_helper'

feature 'Seller edits debtor' do
  scenario 'belonging to their company' do
    seller = create(:seller)
    debtor = create(:debtor, seller: seller)

    visit debtors_path(as: seller.user)
    within(".debtor_#{debtor.id}") do
      click_link 'View'
    end
    click_link 'Edit Customer'

    fill_in 'Business Name', with: 'New Debtor Ltd'
    fill_in 'Main Address', with: '111 New Address'
    fill_in 'ACN', with: '888'
    fill_in 'Relationship start date', with: ''
    click_button 'Edit Debtor'

    expect(page).to have_content 'You have successfully edited your Debtor.'
  end
end
