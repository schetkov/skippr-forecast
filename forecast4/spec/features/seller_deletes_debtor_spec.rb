require 'rails_helper'

feature 'Seller destroys debtor spec' do
  scenario 'debtor belonging to seller' do
    seller = create(:seller)
    debtor = create(:debtor,
                    legal_business_name: 'Debtor Ltd',
                    seller: seller,
                    seller_company: seller.seller_company)

    visit edit_debtor_path(debtor, as: seller.user)
    click_link 'Delete Customer'

    expect(page).not_to have_content 'Debtor Ltd'
    expect(page).to have_content 'Your debtor has been deleted'
  end

  scenario 'debtor belonging to another user' do
    seller = create(:seller)
    another_seller = create(:seller)

    debtor = create(:debtor,
                    legal_business_name: 'Debtor Ltd',
                    seller: seller,
                    seller_company: seller.seller_company)
    create(:invoice, invoice_no: '123', seller: seller, debtor: debtor)

    visit edit_debtor_path(debtor, as: another_seller.user)

    expect(current_path).to eq debtors_path
  end

  scenario 'destroy invoices associated with it' do
    seller = create(:seller)
    debtor = create(:debtor,
                    seller: seller,
                    seller_company: seller.seller_company)
    create(:invoice,
           invoice_no: '123',
           seller: seller,
           debtor: debtor,
           trade: nil)

    visit edit_debtor_path(debtor, as: seller.user)
    click_link 'Delete Customer'
    stub_xero_authorisation_request_token_response
    visit invoices_path

    expect(page).not_to have_content 'Invoice #123'
  end

  scenario 'cannot delete a debtor that has an invoice in a live trade' do
    seller = create(:seller)

    trade = create(:trade, seller: seller)
    debtor = create(:debtor,
                    legal_business_name: 'Debtor Ltd',
                    seller: seller,
                    seller_company: seller.seller_company)
    create(:invoice,
           invoice_no: '123',
           seller: seller,
           debtor: debtor,
           trade: trade)

    visit edit_debtor_path(debtor, as: seller.user)
    click_link 'Delete Customer'

    expect(page).to have_content \
      'Sorry you cannot delete this debtor because it has an invoice being used in a trade'
  end
end
