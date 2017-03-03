require "rails_helper"

feature "Admin approves customer" do
  scenario "pending debtor" do
    admin = create(:user, :admin, email: "admin@example.com", password: "Foobar1234")
    debtor = create(:debtor, status: "pending")

    visit custom_admin_debtor_path(debtor, as: admin)
    click_button "Approve Customer"

    expect(page).to have_content "Approved"
  end
end
