require 'rails_helper'

feature 'Admin sees sellers in dashboard' do
  scenario 'visiting index page' do
    admin = create(:user, :admin, email: 'admin@example.com')
    seller = create(:seller)
    seller.user.update(
      name: 'John Smith',
      email: 'john@example.com'
    )

    visit admin_dashboard_path(as: admin)
    click_link 'Sellers'

    expect(page).to have_content 'John Smith'
    expect(page).to have_content 'john@example.com'
    expect(page).to have_content 'Seller'
  end

  scenario 'visiting show page' do
    admin = create(:user, :admin, email: 'admin@example.com')
    user = create(:user, account_type: 1)
    seller = create(:seller, user: user)

    visit admin_dashboard_path(as: admin)
    click_link 'Sellers'
    within "#seller_#{seller.id}" do
      click_link 'View'
    end

    expect(current_path).to eq admin_seller_path(seller)
  end

  # scenario 'editing a user' do
  #   ENV['ADMIN_EMAILS'] = 'admin@example.com'
  #   admin = create(:user, email: 'admin@example.com')
  #   user = create(:user, :seller)
  #
  #   visit admin_dashboard_path(as: admin)
  #   click_link 'Sellers'
  #   within "tr#seller_#{user.account.id}" do
  #     click_link 'Edit'
  #   end
  #   fill_in 'Name', with: 'Bob Williams'
  #   fill_in 'Email', with: 'bob@example.com'
  #   click_button 'Update User'
  #
  #   expect(page).to have_content 'User was successfully updated.'
  # end
end
