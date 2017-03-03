require 'rails_helper'

feature 'Admin sees invoices in dashboard' do
  scenario 'visiting index page' do
    ENV['ADMIN_EMAILS'] = 'admin@example.com'
    admin = create(:user, :admin, email: 'admin@example.com')
    seller = create(:seller)
    debtor = create(:debtor, seller: seller)
    create(:invoice,
           seller: seller,
           debtor: debtor,
           face_value: 50000)

    visit admin_dashboard_path(as: admin)
    click_link 'Invoices'

    expect(page).to have_content '50000'
  end
end
