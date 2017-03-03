require 'rails_helper'

feature 'Buyer sees sellers list' do
  scenario 'as an approved buyer with approved sellers' do
    user = create(:user, :buyer)
    seller = create(:seller, workflow_state: "completed")
    create(:seller_company,
           name: 'My Company Ltd',
           description: 'This is my company description',
           seller: seller)

    visit buyer_dealboard_path(as: user)
    click_link 'Sellers'

    expect(page).to have_content 'My Company Ltd'
    expect(page).to have_content 'This is my company description'
  end

  scenario 'as an approved buyer with un-approved sellers' do
    user = create(:user, :buyer)
    seller = create(:seller, workflow_state: "completed")
    incomplete_seller = create(:seller, workflow_state: "confirmed")
    create(:seller_company,
           name: 'Other Company Ltd',
           seller: incomplete_seller)
    create(:seller_company,
           name: 'My Company Ltd',
           description: 'This is my company description',
           seller: seller)

    visit buyer_dealboard_path(as: user)
    click_link 'Sellers'

    expect(page).to have_content 'My Company Ltd'
    expect(page).not_to have_content 'Other Company Ltd'
  end

  scenario 'as an un-approved buyer' do
    buyer = create(:buyer, workflow_state: "awaiting_approval")

    visit buyer_dealboard_path(as: buyer.user)

    expect(page).not_to have_content 'Sellers'
  end

  scenario 'as a seller trying to view the sellers list' do
    seller = create(:seller)

    visit sellers_path(as: seller.user)

    expect(page).to have_content "You're not authorized to view that page"
  end
end
