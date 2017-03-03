require 'rails_helper'

feature 'Seller edits profile' do
  scenario 'makes changes to User settings' do
    seller = create(:seller)
    create(:financials, seller_company: seller.seller_company)

    visit seller_path(seller, as: seller.user)
    click_link 'Manage Profile'

    fill_in 'Name', with: 'Joe Bloggs'
    fill_in 'Email', with: 'johnny@example.com'
    click_button 'Update Account'

    expect(field_labeled('Name').value).to eq 'Joe Bloggs'
    expect(field_labeled('Email').value).to eq 'johnny@example.com'
  end

  scenario 'makes changes to Company settings' do
    seller = create(:seller)
    create(:financials, seller_company: seller.seller_company)

    visit seller_path(seller, as: seller.user)
    click_link 'Manage Profile'

    fill_in 'Business name', with: 'My Business'
    fill_in 'Address', with: 'New Address'
    fill_in 'Phone number', with: '9876 5432'
    fill_in 'Website', with: 'http://www.new-website.com'
    fill_in 'ACN', with: '12345'
    fill_in 'Description', with: 'New description'
    click_button 'Update Company'

    expect(field_labeled('Business name').value).to eq 'My Business'
    expect(field_labeled('Address').value).to eq 'New Address'
    expect(field_labeled('Phone number').value).to eq '9876 5432'
    expect(field_labeled('Website').value).to eq 'http://www.new-website.com'
    expect(field_labeled('ACN').value).to eq '12345'
    expect(field_labeled('Description').value).to eq 'New description'
  end
end
