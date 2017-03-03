require 'rails_helper'

feature 'User sees Invoice' do
  scenario 'viewing approved invoice from company profile page' do
    date = (Time.zone.now - 1.week).to_date
    due_date = (Time.zone.now + 1.week).to_date
    anticipated_pay_date = (Time.zone.now + 3.days).to_date
    seller = create(:seller)
    create(:invoice, :with_purchase_order_file,
      seller: seller,
      invoice_no: '123',
      face_value: '10000',
      purchase_order_number: '321',
      date: date,
      due_date: due_date,
      anticipated_pay_date: anticipated_pay_date,
    )

    stub_xero_authorisation_request_token_response
    visit invoices_path(as: seller.user)
    click_link 'Invoice #123'

    expect(page).to have_content '123'
    expect(page).to have_content '$10,000'
    expect(page).to have_content '321'
    expect(page).to have_content date.strftime('%d/%m/%Y')
    expect(page).to have_content due_date.strftime('%d/%m/%Y')
    expect(page).to have_content anticipated_pay_date.strftime('%d/%m/%Y')
  end
end
