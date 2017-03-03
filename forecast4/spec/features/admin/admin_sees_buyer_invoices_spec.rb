require "rails_helper"

feature "Admin sees buyer invoices" do
  scenario "viewing approved invoices where admin has allocated funds for buyer" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    buyer = create(:buyer)
    seller = create(:seller)
    debtor = create(:debtor, legal_business_name: "Woolies")
    create(:invoice, :approved, buyer: buyer, debtor: debtor, seller: seller, face_value: 100_000)
    create(:invoice, :selected, buyer: buyer, debtor: debtor, seller: seller, face_value: 200_000)

    visit custom_admin_buyer_path(buyer, as: admin)

    within(".approved-invoices") do
      expect(page).to have_content "Woolies" # debtor.legal_business_name
      expect(page).to have_content "My Company Ltd" # seller.seller_company_name
      expect(page).to have_content "$85,000" # invoice.advance_amount
      expect(page).not_to have_content "$170,000" # invoice.advance_amount
    end
  end

  scenario "viewing sold invoices - having been traded but not yet funded" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    buyer = create(:buyer)
    trade = create(:trade)
    seller = create(:seller)
    debtor = create(:debtor, legal_business_name: "Woolies")
    create(:invoice, :sold, trade: trade, buyer: buyer, debtor: debtor, seller: seller, face_value: 100_000)
    create(:invoice, :approved, trade: trade, buyer: buyer, debtor: debtor, seller: seller, face_value: 200_000)

    visit custom_admin_buyer_path(buyer, as: admin)

    within(".sold-invoices") do
      expect(page).to have_content "Woolies"
      expect(page).to have_content "My Company Ltd"
      expect(page).to have_content "$85,000"
      expect(page).not_to have_content "$170,000"
    end
  end

  scenario "viewing funded invoices - having been sold and funds deployed" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    buyer = create(:buyer)
    trade = create(:trade)
    seller = create(:seller)
    debtor = create(:debtor, legal_business_name: "Woolies")
    create(:invoice, :funded, trade: trade, buyer: buyer, debtor: debtor, seller: seller, face_value: 100_000)
    create(:invoice, :approved, trade: trade, buyer: buyer, debtor: debtor, seller: seller, face_value: 200_000)

    visit custom_admin_buyer_path(buyer, as: admin)

    within(".funded-invoices") do
      expect(page).to have_content "Woolies"
      expect(page).to have_content "My Company Ltd"
      expect(page).to have_content "$85,000"
      expect(page).not_to have_content "$170,000"
    end
  end

  scenario "viewing repaid invoices - having been sold, funded and repaid" do
    admin = create(:user, :admin, email: 'admin@example.com', password: 'Foobar1234')
    buyer = create(:buyer)
    trade = create(:trade)
    seller = create(:seller)
    debtor = create(:debtor, legal_business_name: "Woolies")
    create(:invoice, :repaid, trade: trade, buyer: buyer, debtor: debtor, seller: seller, face_value: 100_000)
    create(:invoice, :approved, trade: trade, buyer: buyer, debtor: debtor, seller: seller, face_value: 200_000)

    visit custom_admin_buyer_path(buyer, as: admin)

    within(".repaid-invoices") do
      expect(page).to have_content "Woolies"
      expect(page).to have_content "My Company Ltd"
      expect(page).to have_content "$85,000"
      expect(page).not_to have_content "$170,000"
    end
  end
end
