require "rails_helper"

feature "Admin sees invoices" do
  scenario "all invoices" do
    admin = create(:user, :admin)
    create(:invoice, workflow_state: "pending", invoice_no: "INV-001")
    create(:invoice, :approved, invoice_no: "INV-002")

    visit custom_admin_invoices_path(as: admin)
    click_link "All"

    expect(page).to have_content "INV-001"
    expect(page).to have_content "INV-002"
  end

  scenario "pending invoices" do
    admin = create(:user, :admin)
    create(:invoice, workflow_state: "pending", invoice_no: "INV-001")
    create(:invoice, :approved, invoice_no: "INV-002")

    visit custom_admin_invoices_path(as: admin)
    click_link "Pending"

    expect(page).to have_content "INV-001"
    expect(page).not_to have_content "INV-002"
  end

  scenario "selected invoices" do
    admin = create(:user, :admin)
    create(:invoice, workflow_state: "selected", invoice_no: "INV-001")
    create(:invoice, :approved, invoice_no: "INV-002")

    visit custom_admin_invoices_path(as: admin)
    click_link "Selected"

    expect(page).to have_content "INV-001"
    expect(page).not_to have_content "INV-002"
  end

  scenario "approved invoices" do
    admin = create(:user, :admin)
    create(:invoice, workflow_state: "approved", invoice_no: "INV-001")
    create(:invoice, :selected, invoice_no: "INV-002")

    visit custom_admin_invoices_path(as: admin)
    click_link "Approved"

    expect(page).to have_content "INV-001"
    expect(page).not_to have_content "INV-002"
  end

  scenario "sold invoices" do
    admin = create(:user, :admin)
    create(:invoice, workflow_state: "sold", invoice_no: "INV-001")
    create(:invoice, :approved, invoice_no: "INV-002")

    visit custom_admin_invoices_path(as: admin)
    click_link "Sold"

    expect(page).to have_content "INV-001"
    expect(page).not_to have_content "INV-002"
  end

  scenario "funded invoices" do
    admin = create(:user, :admin)
    create(:invoice, workflow_state: "funded", invoice_no: "INV-001")
    create(:invoice, :approved, invoice_no: "INV-002")

    visit custom_admin_invoices_path(as: admin)
    click_link "Funded"

    expect(page).to have_content "INV-001"
    expect(page).not_to have_content "INV-002"
  end

  scenario "repaid invoices" do
    admin = create(:user, :admin)
    create(:invoice, workflow_state: "repaid", invoice_no: "INV-001")
    create(:invoice, :approved, invoice_no: "INV-002")

    visit custom_admin_invoices_path(as: admin)
    click_link "Repaid"

    expect(page).to have_content "INV-001"
    expect(page).not_to have_content "INV-002"
  end
end
