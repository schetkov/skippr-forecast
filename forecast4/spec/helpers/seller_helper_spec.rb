require "rails_helper"

describe SellerHelper do
  describe "#seller_company_status" do
    it "returns companies approved status" do
      seller = build(:seller) 
      build(:seller_company, seller: seller, approved: DateTime.now)

      status = helper.seller_company_status(seller.seller_company)

      expect(status).to eq "Approved"
    end

    it "returns companies unapproved status" do
      seller = build(:seller) 
      build(:seller_company, seller: seller, approved: nil)

      status = helper.seller_company_status(seller.seller_company)

      expect(status).to eq "Awaiting Approval"
    end
  end

  describe "#link_to_admin_seller_path" do
    it "provides a link to admin_seller_path if seller_company exists" do
      seller = create(:seller)

      result = helper.link_to_admin_seller_path(seller)

      expect(result).to include "a href"
    end

    it "returns a string with N/A if no seller_company exists" do
      seller = create(:seller)
      company = seller.seller_company
      company.destroy

      result = helper.link_to_admin_seller_path(seller.reload)

      expect(result).to eq "N/A"
    end
  end
end
