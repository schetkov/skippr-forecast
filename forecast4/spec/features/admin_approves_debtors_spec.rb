require 'rails_helper'

feature 'Admin approves debtor' do
  scenario 'debtors awaiting approval' do
    admin = create_admin_user(email: 'admin@example.com')
    seller = create(:seller)
    debtor = create(:debtor,
                    legal_business_name: 'Debtors Ltd',
                    seller_company: seller.seller_company)

    visit admin_dashboard_path(as: admin)
    click_link 'Debtors'
    within("#debtor_#{debtor.id}") do
      click_button 'Approve Debtor'
    end

    admin_sees_confirmation(message: 'Approved', debtor: debtor)
  end

  def create_admin_user(args = {})
    ENV['ADMIN_EMAILS'] = args.fetch(:email)
    create(:user, :admin, email: args.fetch(:email))
  end

  def admin_sees_confirmation(args = {})
    debtor = args.fetch(:debtor)
    debtor.reload
    within("#debtor_#{debtor.id}") do
      expect(page).to have_content args.fetch(:message)
    end
  end
end
