require 'rails_helper'

feature 'Seller registers invoice' do
  scenario 'with valid attributes awaiting admin approval' do
    seller = create(:seller)
    debtor = create(:debtor, :approved,
                    legal_business_name: 'Debtor Ltd',
                    seller: seller,
                    seller_company: seller.seller_company)
    date = (Date.current - 10.days)
    due_date = (Date.current + 10.days)
    anticipated_pay_date = (Date.current + 5.days)
    stub_xero_authorisation_request_token_response

    visit debtors_path(as: seller.user)
    within(".debtor_#{debtor.id}") do
      click_link "Add Invoice"
    end

    seller_registers_invoice(
      invoice_no: '123',
      face_value: '100000',
      purchase_order_no: '123',
      date: date.strftime("%m/%d/%Y"),
      due_date: due_date.strftime("%m/%d/%Y"),
      anticipated_pay_date: anticipated_pay_date.strftime("%m/%d/%Y")
    )

    seller_sees_invoices_page(seller)
    seller_sees_flash_message('Thank you for registering your invoice')
    seller_sees_invoice(
      invoice_no: 'Invoice #123',
      debtor_name: 'Debtor Ltd',
      invoice_status: 'Pending',
    )
    expect(analytics).to have_tracked("Create Invoice").for_user(seller.user)
  end

  scenario 'with invalid attributes' do
    travel_to Time.new(2015, 03, 31) do
      seller = create(:seller)
      create(:debtor,
             :approved,
             legal_business_name: "Debtor Ltd",
             relationship_start_date: Date.current - 3.years,
             seller: seller,
             seller_company: seller.seller_company)
      date = (Date.current - 31.days)
      due_date =  (Date.current + 91.days)

      visit debtors_path(as: seller.user)
      click_link "Add Invoice"

      # TODO: Create a Form object here to handle min face value validation
      fill_in "Face Value", with: "100"
      fill_in 'Invoice Date', with: date.strftime("%m/%d/%Y")
      fill_in 'Due date', with: due_date.strftime("%m/%d/%Y")
      fill_in 'Anticipated pay date', with: date.strftime("%m/%d/%Y")

      click_button "Create Invoice for Debtor Ltd"

      expect(page).to have_content "Invoice no can't be blank"
      # expect(page).to have_content "Invoice face value cannot be less than AUD$1000"
      # expect(page).to have_content "Purchase order number"
      # expect(page).to have_content "Invoices cannot be older than 30 days"
      expect(page).to have_content "Invoice date and anticipated pay date cannot be the same"
    end
  end

  def seller_registers_invoice(args = {})
    fill_in 'Invoice No', with: args.fetch(:invoice_no)
    fill_in 'Face Value', with: args.fetch(:face_value)
    fill_in 'Purchase Order No', with: args.fetch(:purchase_order_no)
    fill_in 'Invoice Date', with: args.fetch(:date)
    fill_in 'Due date', with: args.fetch(:due_date)
    fill_in 'Anticipated pay date', with: args.fetch(:anticipated_pay_date)
    click_button 'Create Invoice for Debtor Ltd'
  end

  def seller_sees_invoices_page(seller)
    expect(current_path).to eq invoices_path
  end

  def seller_sees_flash_message(message)
    expect(page).to have_content message
  end

  def seller_sees_invoice(args = {})
    invoice = Invoice.last
    within(".invoice_#{invoice.id}") do
      expect(page).to have_content args.fetch(:invoice_no)
      expect(page).to have_content args.fetch(:debtor_name)
      expect(page).to have_content args.fetch(:invoice_status)
      # TODO: Test the merchandise and services fields are being persisted
    end
  end
end
