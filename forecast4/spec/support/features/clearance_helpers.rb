module Features
  module ClearanceHelpers
    def seller_sign_up_with(args)
      visit sign_up_path
      # choose("user_account_type_seller")
      fill_in "registration_user_signup_name", with: args.fetch(:full_name)
      fill_in "registration_user_signup_email", with: args.fetch(:email)
      fill_in "registration_user_signup_company_name", with: args.fetch(:company_name)
      fill_in "registration_user_signup_acn", with: args.fetch(:acn)
      fill_in "registration_user_signup_website", with: args.fetch(:website)
      fill_in "registration_user_signup_phone_number", with: args.fetch(:phone_number)
      fill_in "registration_user_signup_exchange_fee", with: args.fetch(:phone_number)
      fill_in "registration_user_signup_password", with: args.fetch(:password)
      click_button I18n.t("helpers.submit.user.create")
    end

    def buyer_sign_up_with(name, email,company_name, phone_number, password)
      visit sign_up_path
      choose("user_account_type_buyer")
      fill_in "user_name", with: name
      fill_in "user_email", with: email
      fill_in "user_company_name", with: company_name
      fill_in "user_phone_number", with: phone_number
      fill_in "user_password", with: password
      click_button I18n.t("helpers.submit.user.create")
    end

    def sign_in_with(email, password)
      visit sign_in_path
      fill_in "session_email", with: email
      fill_in "session_password", with: password
      click_button I18n.t("helpers.submit.session.submit")
    end

    def signed_in_user
      password = "Foobar1234"
      user = create(:user, :seller, password: password)
      sign_in_with user.email, password
      user
    end

    def user_should_be_signed_in
      within(".sign-out") do
        expect(page).to have_css("a#sign-out")
      end
    end

    def sign_out
      find_link("sign-out").click
    end

    def user_should_be_signed_out
      expect(page).to have_content I18n.t("layouts.application.sign_in")
    end

    def user_with_reset_password
      seller = create(:seller)
      user = seller.user
      reset_password_for user.email
      user.reload
    end

    def reset_password_for(email)
      visit new_password_path
      fill_in "password_email", with: email
      click_button I18n.t("helpers.submit.password.submit")
    end
  end
end
