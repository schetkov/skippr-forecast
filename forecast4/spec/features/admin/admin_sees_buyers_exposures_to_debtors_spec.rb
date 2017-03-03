require "rails_helper"

feature "Buyer sees exposures to debtors" do
  scenario "with funds allocated" do
    admin = create(:user, :admin)
    buyer = create(:buyer)
    debtor = create(:debtor)
    create(:mandate, buyer: buyer, debtor: debtor)
    # Advance amount in dollars is $8500/85%
    create(:invoice, :approved, face_value: 10_000, buyer: buyer, debtor: debtor)
    visit custom_admin_buyer_path(buyer, as: admin)

    within(".debtor_cash_allocated_#{debtor.id}") do
      expect(page).to have_content "$8,500"
    end
    within(".debtor_current_exposure_#{debtor.id}") do
      expect(page).to have_content "$8,500"
    end
  end

  scenario "with funds allocated and deployed" do
    admin = create(:user, :admin)
    buyer = create(:buyer)
    debtor = create(:debtor)
    other_debtor = create(:debtor)
    create(:mandate, buyer: buyer, debtor: debtor)
    # Advance amount in dollars is $8500/85%
    create(:invoice, :approved, face_value: 10_000, buyer: buyer, debtor: debtor)
    trade = create(:trade)
    create(:invoice, :funded, trade: trade, face_value: 10_000, buyer: buyer, debtor: other_debtor)
    visit custom_admin_buyer_path(buyer, as: admin)

    within(".debtor_cash_allocated_#{debtor.id}") do
      expect(page).to have_content "$8,500"
    end
    within(".debtor_funds_deployed_#{other_debtor.id}") do
      expect(page).to have_content "$8,500"
    end
    within(".debtor_current_exposure_#{debtor.id}") do
      expect(page).to have_content "$8,500"
    end
  end
end
