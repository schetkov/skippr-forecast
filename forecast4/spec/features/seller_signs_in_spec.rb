require 'rails_helper'

feature 'Seller signs in' do
  scenario 'views the dashboard' do
    user = create(:user, :seller, email: 'valid@example.com', password: 'Foobar1234')

    sign_in_with('valid@example.com', 'Foobar1234')

    expect(current_path).to eq seller_dashboard_path
    expect(analytics).to have_tracked("Sign In User").for_user(user)
  end
end
