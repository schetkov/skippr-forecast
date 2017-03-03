require "rails_helper"

feature "Admin approves User" do
  scenario "who is applying as a seller" do
    create_admin_user(email: "admin@example.com", password: "Foobar1234")
    user = create(:user, name: "John Smith")
    create(:seller, workflow_state: "new", user: user)

    sign_in_with("admin@example.com", "Foobar1234")
    click_link "Sellers"
    click_link "New Sellers"
    click_button "Move to Next Step"

    admin_sees_flash_message "John Smith has been confirmed."
    admin_sees_tab_count_increased(".business_registration", "(1)")
  end

  scenario "cannot move a confirmed seller to next step" do
    create_admin_user(email: "admin@example.com", password: "Foobar1234")
    user = create(:user, name: "John Smith")
    create(:seller, workflow_state: "confirmed", user: user)

    sign_in_with("admin@example.com", "Foobar1234")
    click_link "Sellers"
    click_link "Business Registration"

    admin_does_not_see_button_to_move_user(".move-user-state")
  end

  # scenario "who is applying as a buyer" do
  #   create_admin_user(email: "admin@example.com", password: "password")
  #   user = create(:user, name: "John Smith", account_type: "buyer")
  #   create(:buyer, :awaiting_approval, user: user)
  #
  #   sign_in_with("admin@example.com", "password")
  #   click_link "Buyers"
  #   click_link "Awaiting Approval"
  #   click_button "Move to Next Step"
  #
  #   admin_sees_flash_message "John Smith has been approved."
  #   admin_sees_tab_count_increased(".complete", "(1)")
  # end

  # scenario "cannot move a complete buyer to next step" do
  #   create_admin_user(email: "admin@example.com", password: "password")
  #   create(:user, :buyer)
  #
  #   sign_in_with("admin@example.com", "password")
  #   click_link "Buyers"
  #   click_link "Complete"
  #
  #   admin_does_not_see_button_to_move_user(".move-user-state")
  # end

  def create_admin_user(args = {})
    create(:user, :admin, email: args.fetch(:email), password: args.fetch(:password))
  end

  def admin_sees_flash_message(flash_message)
    expect(page).to have_content flash_message
  end

  def admin_sees_tab_count_increased(tab_name, count)
    within(tab_name) do
      expect(page).to have_content count
    end
  end

  def admin_does_not_see_button_to_move_user(button_class)
    expect(page).not_to have_css button_class
  end
end
