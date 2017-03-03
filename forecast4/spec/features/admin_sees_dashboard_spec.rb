require 'rails_helper'

feature 'Admin views dashboard' do
  scenario 'with admin credentials and a seller' do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    seller = create(:seller)
    seller.user.update(
      name: "John Smith",
      email: 'valid@example.com'
    )
    seller.seller_company.update(name: 'Woolies Ltd')

    sign_in_with('admin@example.com', 'Foobar1234')

    expect(current_path).to eq admin_dashboard_path
    expect(page).to have_content 'John Smith'
    expect(page).to have_content 'valid@example.com'
    expect(page).to have_content 'Woolies Ltd'
    expect(page).to have_content 'Seller'
  end

  scenario 'with admin credentials and a buyer' do
    admin = create(:user, :admin, email: 'admin@example.com')
    buyer = create(:buyer)
    buyer.user.update(
      name: 'John Smith',
      email: 'valid@example.com',
    )

    visit admin_dashboard_path(as: admin)

    expect(page).to have_content 'John Smith'
    expect(page).to have_content 'valid@example.com'
    expect(page).to have_content 'Buyer'
  end

  scenario 'with normal user credentials' do
     user = create(:user, :seller, email: 'valid@example.com', password: 'Foobar1234')

     visit seller_dashboard_url(as: user)

     expect(page).not_to have_content 'Admin Dashboard'
  end
end
