require 'rails_helper'

feature 'Seller uploads financial information' do

  scenario 'viewing own profile page' do
    seller = create(:seller)
    visit seller_path(seller, as: seller.user)

    within('.financial-statements') do
      expect(page).to have_css '#new_financial_statement'
    end
    within('.bank-statements') do
      expect(page).to have_css '#new_bank_statements'
    end
  end
end
