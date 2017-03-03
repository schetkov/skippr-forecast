require 'rails_helper'

feature 'Seller manages customer receipts' do
  # TODO: Capybara webkit compains about overlapping element due to upload css
  # basically hiding the native file upload button.
  #
  # scenario 'uploading a new receipt from debtor page', js: true do
  #   user = create(:user, :seller)
  #   debtor = create(:debtor, seller: user.account)
  #
  #   visit company_debtor_path(user.company, debtor, as: user)
  #   attach_file 'cloudinary-upload', Rails.root.join('spec', 'fixtures', 'files', 'test_file.pdf')
  #   find(:css, 'a#upload').click
  #   click('Create Customer receipt')
  #
  #   expect(page).to have_content 'Test file'
  # end

  # scenario 'uploading during registration of a debtor' do
  #   user = create(:user, :seller)
  #   visit new_debtor_path(as: user)
  #
  #   within('.new-customer-invoices') do
  #     expect(page).to have_css '#filepicker-widget'
  #   end
  # end
  #
  # We removed option to delete files for now
  # scenario 'destroying an existing receipt as seller' do
  #   user = create(:user, :seller)
  #   debtor = create(:debtor, seller: user.account)
  #   customer_receipt = create(:customer_receipt, debtor: debtor, file_name: 'Test file')
  #
  #   visit seller_debtor_path(user.account, debtor, as: user)
  #   within(".customer_receipt_#{customer_receipt.id}") do
  #     click_link 'Delete'
  #   end
  #
  #   expect(page).not_to have_content 'Test file'
  # end
  #
  # scenario 'destroying an existing receipt as another user' do
  #   user = create(:user, :seller)
  #   another_user = create(:user, :seller)
  #   debtor = create(:debtor, seller: user.account)
  #   create(:customer_receipt, debtor: debtor, file_name: 'Test file')
  #
  #   visit seller_debtor_path(user.account, debtor, as: another_user)
  #
  #   expect(page).not_to have_content 'Delete'
  # end
end
