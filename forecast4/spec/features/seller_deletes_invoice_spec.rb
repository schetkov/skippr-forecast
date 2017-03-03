require 'rails_helper'

feature 'Seller deletes invoice' do
  scenario 'when invoice is not in use' do
    seller = create(:seller)
    invoice = create(:invoice,
                     invoice_no: '123',
                     trade_id: nil,
                     seller: seller)
    stub_xero_authorisation_request_token_response

    visit invoices_path(as: seller.user)
    within(".invoice_#{invoice.id}") do
      click_link 'View'
    end
    click_link 'Delete'

    expect(page).not_to have_content 'Invoice #123'
  end

  scenario 'when invoice is being used in a confirmed trade' do
    seller = create(:seller)
    trade = create(:trade, :confirmed, seller: seller)
    invoice = create(:invoice,
                     invoice_no: '123',
                     trade: trade,
                     seller: seller)
    stub_xero_authorisation_request_token_response

    visit invoices_path(as: seller.user)
    within(".invoice_#{invoice.id}") { click_link 'View' }
    click_link 'Delete'

    expect(page).to have_content \
      'Sorry you cannot delete this invoice as it is currently being used in a live trade'
    expect(page).to have_content 'Invoice #123'
  end

  scenario 'when invoice is being used in an unconfirmed trade' do
    seller = create(:seller)
    trade = create(:trade, seller: seller)
    invoice = create(:invoice,
                     invoice_no: '123',
                     trade: trade,
                     seller: seller)
    stub_xero_authorisation_request_token_response

    visit invoices_path(as: seller.user)
    within(".invoice_#{invoice.id}") { click_link 'View' }
    click_link 'Delete'

    expect(page).not_to have_content 'Invoice #123'
  end
end
