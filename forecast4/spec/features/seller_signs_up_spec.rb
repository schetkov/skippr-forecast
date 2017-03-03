require "rails_helper"

feature "Seller signs up" do
  scenario "as a Xero user" do
    request_token = double("request_token_response",
                           authorize_url: xero_session_path,
                           token: "123",
                           secret: "321")
    allow_any_instance_of(XeroAuthorisation).to receive(:request_token_response).
      and_return(request_token)
    admin = create_admin_user(email: "admin@example.com", password: "Foobar1234")
    visit new_custom_admin_seller_path(as: admin)
    create_new_seller_as_admin
    click_on "sign-out"

    user = User.find_by(email: "valid@example.com")
    seller = user.seller
    expect(seller.workflow_state).to eq "business_registration"

    sign_in_with "valid@example.com", "Foobar1234"
    select "Xero"
    choose("existing_facility_check_yes")
    within(".existing-facilities") do
      fill_in "registration_business_registrar_existing_facility__name", with: "Factoring Co Ltd"
      fill_in "registration_business_registrar_existing_facility__amount", with: "15000"
      select "Secured", from: "registration_business_registrar_existing_facility__secured"
    end
    stub_financial_statements_upload
    attach_file "fs-upload", test_file_1
    attach_file "bs-upload", test_file_2
    click_button "Add Customers"

    expect(analytics).to have_tracked("Business Registration").for_user(user)
    expect(seller.reload.workflow_state).to eq "customer_registration"
    expect(page).to have_content "Xero account"

    xero_authorisation = create(:xero_authorisation, seller: Seller.last)
    allow(XeroDataRetrieverJob).to receive(:perform_later).
      with(xero_id: xero_authorisation.id, seller_id: seller.id)

    click_on "xero-connect"

    expect(analytics).to have_tracked("Customer Registration with Xero").for_user(user)
    expect(current_path).to eq terms_wizard_path

    fill_in "Director's Name", with: "Bob Smith"
    fill_in "Director's Address", with: "101 Address, Sydney, Australia"
    fill_in "Director's Email", with: "bob@example.com"
    fill_in "Driver License Number", with: "123456"
    fill_in "registration_terms_registrar_dob_day", with: "2"
    fill_in "registration_terms_registrar_dob_month", with: "12"
    fill_in "registration_terms_registrar_dob_year", with: "1985"
    stub_docusign_request
    click_button "Go to Seller Dashboard"

    expect(analytics).to have_tracked("Terms Registration").for_user(user)
    expect(current_path).to eq seller_dashboard_path
    expect(seller.reload.workflow_state).to eq "completed"
  end

  scenario "with failed xero import" do
    seller = create(:seller, error_importing_from_xero: Date.current)

    visit seller_dashboard_path(as: seller.user)
    within(".failed-import") do
      click_link "click here"
    end

    expect(page).to have_content "Xero account"
  end

  scenario "as a non-Xero user" do
    admin = create_admin_user(email: "admin@example.com", password: "Foobar1234")
    visit new_custom_admin_seller_path(as: admin)
    create_new_seller_as_admin
    click_on "sign-out"

    user = User.find_by(email: "valid@example.com")
    seller = user.seller
    expect(seller.workflow_state).to eq "business_registration"

    sign_in_with "valid@example.com", "Foobar1234"
    select "Other"
    choose("existing_facility_check_yes")
    within(".existing-facilities") do
      fill_in "registration_business_registrar_existing_facility__name", with: "Factoring Co Ltd"
      fill_in "registration_business_registrar_existing_facility__amount", with: "15000"
      select "Secured", from: "registration_business_registrar_existing_facility__secured"
    end
    stub_financial_statements_upload
    attach_file "fs-upload", test_file_1
    attach_file "bs-upload", test_file_2
    click_button "Add Customers"

    expect(analytics).to have_tracked("Business Registration").for_user(user)
    expect(seller.reload.workflow_state).to eq "customer_registration"
    expect(page).to have_content "My Customers"

    fill_in "Customer Name", with: "Bob Smith"
    fill_in "ACN", with: "123456"
    fill_in "Value of Outstanding Invoices", with: 15_000
    click_button "Review Terms & Conditions"

    expect(analytics).to have_tracked("Customer Registration").for_user(user)
    expect(current_path).to eq terms_wizard_path

    fill_in "Director's Name", with: "Bob Smith"
    fill_in "Director's Address", with: "101 Address, Sydney, Australia"
    fill_in "Director's Email", with: "bob@example.com"
    fill_in "Driver License Number", with: "123456"
    fill_in "registration_terms_registrar_dob_day", with: "2"
    fill_in "registration_terms_registrar_dob_month", with: "12"
    fill_in "registration_terms_registrar_dob_year", with: "1985"
    stub_docusign_request
    click_button "Go to Seller Dashboard"

    expect(analytics).to have_tracked("Terms Registration").for_user(user)
    expect(current_path).to eq seller_dashboard_path
  end

  scenario "as a non-Xero user without financial statements" do
    admin = create_admin_user(email: "admin@example.com", password: "Foobar1234")
    visit new_custom_admin_seller_path(as: admin)
    create_new_seller_as_admin
    click_on "sign-out"

    sign_in_with "valid@example.com", "Foobar1234"
    select "Other"
    choose("existing_facility_check_yes")
    within(".existing-facilities") do
      fill_in "registration_business_registrar_existing_facility__name", with: "Factoring Co Ltd"
      fill_in "registration_business_registrar_existing_facility__amount", with: "15000"
      select "Secured", from: "registration_business_registrar_existing_facility__secured"
    end
    click_button "Add Customers"

    expect(page).to have_content "Financial statements can't be blank"
  end

  #
  # Stubbing out financial_statements since Cloudinary uses direct upload
  # to the browser which we don't simulate in Capybara
  #
  def stub_financial_statements_upload
    allow_any_instance_of(Registration::BusinessRegistrar).
      to receive(:financial_statements).
      and_return(["image/upload/v1446766428/financial_statements/test-file.pdf#36291161a3e0c489a8876be5de9dfe6cb96095b2"])
  end

  def create_admin_user(args = {})
    ENV['ADMIN_EMAILS'] = args.fetch(:email)
    create(:user, :admin, email: args.fetch(:email))
  end

  def test_file_1
    Rails.root.join("spec", "fixtures", "files", "test_file.pdf")
  end

  def test_file_2
    Rails.root.join("spec", "fixtures", "files", "test_file_1.pdf")
  end

  def stub_docusign_request
    allow_any_instance_of(Esignature::Esignor).to receive(:request_signature).
      and_return(true)
  end

  def create_new_seller_as_admin
    fill_in "Name", with: "Test Seller"
    fill_in "Email", with: "valid@example.com"
    fill_in "Company name", with: "Test Company Name"
    fill_in "ACN", with: "123456"
    fill_in "Website", with: "www.website.com"
    fill_in "Phone number", with: "1234 4567"
    fill_in "Exchange Fee", with: 0.01
    fill_in "Password", with: "Foobar1234"
    click_button "Create Seller"
  end
end
