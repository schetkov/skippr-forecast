require 'rails_helper'

feature 'User sees sellers debtors on company profile page' do
  scenario 'as seller viewing own debtors' do
    seller = create(:seller)
    debtor = create(
      :debtor,
      :approved,
      legal_business_name: 'Debtor Ltd',
      seller: seller,
      seller_company: seller.seller_company
    )
    create(:invoice, seller: seller, debtor: debtor)

    visit debtors_path(as: seller.user)

    seller_sees_debtor_information(
      debtor_name: 'Debtor Ltd',
      status: 'Approved',
      invoice_count: '1'
    )
  end

  scenario 'with no debtors' do
    seller = create(:seller)

    visit debtors_path(as: seller.user)

    expect(page).to have_content "please register a customer first"
  end

  def seller_sees_debtor_information(args)
    within('.debtors') do
      expect(page).to have_content args.fetch(:debtor_name)
      expect(page).to have_content args.fetch(:status)
      expect(page).to have_content args.fetch(:invoice_count)
    end
  end
end
