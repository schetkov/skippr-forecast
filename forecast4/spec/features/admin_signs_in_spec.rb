require 'rails_helper'

feature 'Admin signs in' do
  scenario 'with admin credentials' do
    create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')

    sign_in_with('admin@example.com', 'Foobar1234')

    expect(current_path).to eq admin_dashboard_path
  end
end
