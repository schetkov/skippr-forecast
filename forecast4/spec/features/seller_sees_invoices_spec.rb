require "rails_helper"

feature "Seller views invoices" do
  scenario "with multiple invoices" do
    seller = create(:seller)
    invoice = create(:invoice,
                     invoice_no: "123",
                     face_value: 10000,
                     date: (Date.current - 20.days),
                     due_date: (Date.current + 10.days),
                     seller: seller)

    invoice.debtor.update(legal_business_name: "Debtor Ltd")

    stub_xero_authorisation_request_token_response
    visit invoices_path(as: seller.user)

    seller_sees_invoice_information(
      invoice_no: "123",
      face_value: "$10,000",
      debtor_name: "Debtor Ltd",
    )
  end

  scenario "with no invoices" do
    seller = create(:seller)

    stub_xero_authorisation_request_token_response
    visit invoices_path(as: seller.user)

    expect(page).to have_content "To add a new invoice"
  end

  def seller_sees_invoice_information(args)
    within(".invoices") do
      expect(page).to have_content args.fetch(:invoice_no)
      expect(page).to have_content args.fetch(:face_value)
      expect(page).to have_content args.fetch(:debtor_name)
    end
  end
end
