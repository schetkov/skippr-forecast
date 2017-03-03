require 'rails_helper'

RSpec.describe BuyerCompany, type: :model do
  it "has a valid factory" do
    expect(build(:buyer_company)).to be_valid
  end

  context "associations" do
    it { should belong_to(:buyer) }
    it { should have_one(:bank_details) }
    it { should have_one(:accountant) }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
  end

  describe ".ordered" do
    it "returns the latest 10 records" do
      first_buyer_company = create(:buyer_company)
      10.times { create(:buyer_company) }
      last_buyer_company = create(:buyer_company)

      ordered_buyer_companies = BuyerCompany.ordered

      expect(ordered_buyer_companies.length).to eq 10
      expect(ordered_buyer_companies.first).to eq last_buyer_company
      expect(ordered_buyer_companies).not_to include first_buyer_company
    end
  end
end
