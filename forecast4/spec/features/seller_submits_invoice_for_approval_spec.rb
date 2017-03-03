require "rails_helper"

feature "Seller submit invoice for approval" do
  scenario "with valid anticipated pay date" do
    seller = create(:seller)
    create(:invoice, workflow_state: "pending", seller: seller)

    visit seller_dashboard_path(as: seller.user)
    click_link "Pending Invoices"
    click_link "Submit for approval"
    fill_in "invoice_anticipated_pay_date", with: (Date.current + 10.days).strftime("%m/%d/%Y")
    attach_file "cloudinary-upload",
      Rails.root.join("spec", "fixtures", "files", "test_file.pdf")
    click_button "Submit for Approval"
    click_link "Pending Invoices"

    expect(page).to have_content "Awaiting approval"
    expect(analytics).to have_tracked("Invoice Submitted For Approval").
      for_user(seller.user)
  end

  scenario "with invalid anticipated pay date" do
    seller = create(:seller)
    create(:invoice, workflow_state: "pending", seller: seller)

    visit seller_dashboard_path(as: seller.user)
    click_link "Pending Invoices"
    click_link "Submit for approval"
    fill_in "invoice_anticipated_pay_date", with: "invalid input"
    attach_file "cloudinary-upload",
      Rails.root.join("spec", "fixtures", "files", "test_file.pdf")
    click_button "Submit for Approval"

    expect(page).not_to have_content "Awaiting approval"
  end

  scenario "with anticipated pay date before due date" do
    seller = create(:seller)
    create(:invoice,
           workflow_state: "pending",
           due_date: Date.current + 10.days,
           seller: seller)

    visit seller_dashboard_path(as: seller.user)
    click_link "Pending Invoices"
    click_link "Submit for approval"
    fill_in "invoice_anticipated_pay_date", with: Date.current.strftime("%m/%d/%Y")
    attach_file "cloudinary-upload",
      Rails.root.join("spec", "fixtures", "files", "test_file.pdf")
    click_button "Submit for Approval"

    expect(page).not_to have_content "Awaiting approval"
  end

  scenario "with blank anticipated pay date" do
    seller = create(:seller)
    create(:invoice, workflow_state: "pending", seller: seller)

    visit seller_dashboard_path(as: seller.user)
    click_link "Pending Invoices"
    click_link "Submit for approval"
    fill_in "invoice_anticipated_pay_date", with: ""
    attach_file "cloudinary-upload",
      Rails.root.join("spec", "fixtures", "files", "test_file.pdf")
    click_button "Submit for Approval"
    click_link "Pending Invoices"

    expect(page).not_to have_content "Awaiting approval"
  end
end
