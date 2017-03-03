require "rails_helper"

feature "Admin approves invoice" do
  scenario "invoice awaiting approval with rating" do
    admin = create_admin_user(email: "admin@example.com")
    seller = create(:seller)
    debtor = create(:debtor, seller: seller, status: "approved")
    invoice = create(:invoice,
                     seller: seller,
                     debtor: debtor,
                     workflow_state: "selected")
    create(:rating, invoice: invoice)

    visit admin_dashboard_path(as: admin)
    click_link "Invoices"
    click_link "With Selected State"
    within("#invoice_#{invoice.id}") do
      click_button "Approve Invoice"
    end

    admin_sees_confirmation(status: "Approved", invoice: invoice)
  end

  scenario "invoice awaiting approval without rating" do
    admin = create_admin_user(email: "admin@example.com")
    seller = create(:seller)
    debtor = create(:debtor, seller: seller, status: "approved")
    invoice = create(:invoice,
                     seller: seller,
                     debtor: debtor,
                     workflow_state: "selected")

    visit admin_dashboard_path(as: admin)
    click_link "Invoices"
    click_link "With Selected State"
    within("#invoice_#{invoice.id}") do
      click_button "Approve Invoice"
    end

    expect(page).to have_content "Please apply rating to invoice"
  end

  def create_admin_user(args = {})
    create(:user, :admin, email: args.fetch(:email))
  end

  def admin_sees_confirmation(args = {})
    invoice = args.fetch(:invoice)
    invoice.reload
    within("#invoice_#{invoice.id}") do
      expect(page).to have_content args.fetch(:status)
    end
  end
end
