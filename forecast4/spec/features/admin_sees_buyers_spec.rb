require 'rails_helper'

feature 'Admin sees buyers in dashboard' do
  scenario 'visiting index page' do
    admin = create(:user, :admin, email: 'admin@example.com')
    buyer = create(:buyer)
    buyer.user.update(
      name: 'John Smith',
      email: 'valid@example.com'
    )

    visit admin_dashboard_path(as: admin)
    click_link 'Buyers'

    expect(page).to have_content 'John Smith'
    expect(page).to have_content 'valid@example.com'
    expect(page).to have_content 'Buyer'
  end

  # scenario 'visiting show page' do
  #   ENV['ADMIN_EMAILS'] = 'admin@example.com'
  #   admin = create(:user, email: 'admin@example.com', password: 'password')
  #   user = create(:buyer_user, name: 'John Smith',
  #                        email: 'valid@example.com')

  #   visit admin_dashboard_path(as: admin)
  #   click_link 'Buyers'
  #   within "#buyer_#{user.account.id}" do
  #     click_link 'View'
  #   end

  #   expect(current_path).to eq admin_user_path(user)
  # end

  # scenario 'editing a user' do
  #   ENV['ADMIN_EMAILS'] = 'admin@example.com'
  #   admin = create(:user, email: 'admin@example.com', password: 'password')
  #   seller = create(:seller, registration_status: 'step_one')
  #   create(:user, name: 'John Smith',
  #                        email: 'valid@example.com',
  #                        account: seller)

  #   visit admin_dashboard_path(as: admin)
  #   click_link 'Sellers'
  #   within "#seller_#{seller.id}" do
  #     click_link 'Edit'
  #   end
  #   fill_in 'Name', with: 'Bob Williams'
  #   fill_in 'Email', with: 'bob@example.com'
  #   click_button 'Update User'

  #   expect(page).to have_content 'User was successfully updated.'
  # end
end
