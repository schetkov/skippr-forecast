require 'rails_helper'

feature 'Seller registers a new debtor' do
  scenario 'with valid attributes' do
    seller = create(:seller, workflow_state: "completed")

    visit debtors_path(as: seller.user)
    click_link 'Add a new Customer'

    seller_fills_in_form(
      legal_business_name: 'Debtor Ltd',
      main_address: '500 Business Street',
      acn: '987654321',
      website: 'http://www.website.com',
      relationship_start_date: "01/01/2001"
    )

    seller_sees_debtors_path
    seller_sees_debtor_listing(
      name: 'Debtor Ltd',
      status: 'pending',
      status_message: 'Pending'
    )

    expect(analytics).to have_tracked("Create Customer").for_user(seller.user)
  end

  # TODO: This is really an Admin test
  scenario 'registers a debtor and admin approves' do
    admin = create_admin_user(email: 'admin@example.com', password: 'Foobar1234')
    seller = create(:seller)
    create(:debtor,
           legal_business_name: 'Debtor Ltd',
           internal_account_debtor_id: '123',
           seller: seller,
           seller_company: seller.seller_company)

    visit admin_debtors_path(as: admin)
    click_button 'Approve Debtor'
    click_link 'Logout'

    visit debtors_path(as: seller.user)

    seller_sees_debtor_listing(
      name: 'Debtor Ltd',
      status: 'approved',
      status_message: 'Add Invoice'
    )
  end

  def create_admin_user(args = {})
    create(:user, :admin, email: args.fetch(:email), password: args.fetch(:password))
  end

  def create_seller_who_has_completed_registration(args = {})
    seller = create(:seller, status: args.fetch(:status))
    create(:user, email: args.fetch(:email),
                         password: args.fetch(:password),
                         account: seller)
  end

  def seller_fills_in_form(args = {})
    fill_in 'Business Name', with: args.fetch(:legal_business_name)
    fill_in 'Main Address', with: args.fetch(:main_address)
    fill_in 'ACN', with: args.fetch(:acn)
    fill_in 'Website', with: args.fetch(:website)
    fill_in 'Relationship start date', with: args.fetch(:relationship_start_date)
    attach_file 'cloudinary-upload', Rails.root.join('spec', 'fixtures', 'files', 'test_file.pdf')
    click_button 'Register Customer'
  end

  def seller_sees_debtors_path
    expect(current_path).to eq debtors_path
  end

  def seller_sees_debtor_listing(args = {})
    within('.debtors') do
      expect(page).to have_content args.fetch(:name)
      expect(page).to have_content args.fetch(:status_message)
    end
  end
end
