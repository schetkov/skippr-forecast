require "rails_helper"

feature "Seller sees Credit Report" do
  scenario "as current user/seller" do
    seller = create(:seller)
    create(:attachment,
           :credit_report,
           file_name: "Latest credit report",
           attachable: seller)

    visit seller_path(seller, as: seller.user)

    expect(page).to have_content "Latest credit report"
  end

  # TODO: Write controller spec for this as well
  scenario "as another seller" do
    seller = create(:seller)
    another_seller = create(:seller)
    create(:attachment,
           :credit_report,
           file_name: "Latest credit report",
           attachable: seller)

    visit seller_path(seller, as: another_seller.user)

    expect(page).not_to have_content "Latest credit report"
  end

  scenario "as a buyer" do
    seller = create(:seller)
    buyer = create(:buyer)
    create(:attachment,
           :credit_report,
           file_name: "Latest credit report",
           attachable: seller)

    visit seller_path(seller, as: buyer.user)

    expect(page).to have_content "Latest credit report"
  end
end
