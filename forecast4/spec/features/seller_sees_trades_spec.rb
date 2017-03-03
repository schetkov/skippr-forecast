require "rails_helper"

feature "Seller sees trades" do
  scenario "with confirmed trades" do
    seller = create(:seller)
    trade = create(:trade,
                   confirmed_at: Date.current,
                   total_face_value: 10000,
                   advance_amount: 9000,
                   discount_fee: 1000,
                   seller: seller)

    visit trades_path(as: seller.user)

    within ".trade_#{trade.id}" do
      expect(page).to have_content trade.confirmed_at.strftime("%d %B")
      expect(page).to have_content "$10,000"
      expect(page).to have_content "$9,000"
      expect(page).to have_content "$1,000"
    end
  end
end
