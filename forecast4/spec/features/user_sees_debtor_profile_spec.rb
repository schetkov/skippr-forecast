require 'rails_helper'

feature "User sees Debtor's Profile" do
  scenario 'viewing approved debtor from company profile page' do
    seller = create(:seller)
    create(:debtor,
           :approved,
           seller: seller,
           legal_business_name: 'Woolies Ltd',
           address: 'Room 111 Some Address',
           acn: '12345',
           website: 'http://somewebsite.com',
           business_type: 'Private',
           business_sector: 'Supermarket',
           seller_company: seller.seller_company)

    visit debtors_path(as: seller.user)
    click_link 'Woolies Ltd'

    expect(page).to have_content 'Customer Profile for Woolies Ltd'
    expect(page).to have_content 'Room 111 Some Address'
    expect(page).to have_content '12345'
    expect(page).to have_content 'http://somewebsite.com'
    expect(page).to have_content 'Private'
    expect(page).to have_content 'Supermarket'
    expect(page).to have_content 'Approved'
  end
end

