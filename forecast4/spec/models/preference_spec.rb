require 'rails_helper'

describe Preference do
  it "should have a valid factory" do
    expect(build(:preference)).to be_valid
  end

  context "validations" do
    it { should validate_presence_of(:buyer_exchange_fee) }
    it { should validate_presence_of(:seller_exchange_fee) }
  end
end

describe Preference do
  describe ".seller_exchange_fee" do
    it "takes the last record and returns the seller_exchange_fee attribute" do
      create(:preference, seller_exchange_fee: 0.02)
      create(:preference, seller_exchange_fee: 0.01)

      seller_exchange_fee = Preference.seller_exchange_fee

      expect(seller_exchange_fee).to eq 0.01
      expect(seller_exchange_fee).not_to eq 0.02
    end
  end

  describe ".buyer_exchange_fee" do
    it "takes the last record and returns the buyer_exchange_fee attribute" do
      create(:preference, buyer_exchange_fee: 0.02)
      create(:preference, buyer_exchange_fee: 0.01)

      buyer_exchange_fee = Preference.buyer_exchange_fee

      expect(buyer_exchange_fee).to eq 0.01
      expect(buyer_exchange_fee).not_to eq 0.02
    end
  end
end
