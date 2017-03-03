require "rails_helper"

feature "Admin sees customers" do
  scenario "all customers" do
    admin = create(:user, :admin)
    create(:debtor, legal_business_name: "Pending Customer", status: "pending")
    create(:debtor, legal_business_name: "Approved Customer", status: "approved")

    visit custom_admin_debtors_path(as: admin)
    click_link "All"

    expect(page).to have_content "Pending Customer"
    expect(page).to have_content "Approved Customer"
  end

  scenario "pending customers" do
    admin = create(:user, :admin)
    create(:debtor, legal_business_name: "Pending Customer", status: "pending")
    create(:debtor, legal_business_name: "Approved Customer", status: "approved")

    visit custom_admin_debtors_path(as: admin)
    click_link "Pending"

    expect(page).to have_content "Pending Customer"
    expect(page).not_to have_content "Approved Customer"
  end

  scenario "approved customers" do
    admin = create(:user, :admin)
    create(:debtor, legal_business_name: "Pending Customer", status: "pending")
    create(:debtor, legal_business_name: "Approved Customer", status: "approved")

    visit custom_admin_debtors_path(as: admin)
    click_link "Approved"

    expect(page).not_to have_content "Pending Customer"
    expect(page).to have_content "Approved Customer"
  end
end
