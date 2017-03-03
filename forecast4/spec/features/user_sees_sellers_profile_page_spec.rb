require "rails_helper"

feature "User sees Seller's company profile page" do
  scenario "viewing another seller's profile page" do
    seller = create(:seller)
    another_seller = create(:seller)

    visit seller_path(seller, as: another_seller.user)

    expect(current_path).to eq seller_dashboard_path
    expect(page).to have_content "You're not authorized"
  end
end
