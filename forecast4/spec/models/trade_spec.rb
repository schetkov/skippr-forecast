require 'rails_helper'

describe Trade do
  it "has a valid factory" do
    expect(create(:trade)).to be_valid
  end

  context "associations" do
    it { should belong_to(:seller) }
    it { should have_many(:invoices) }
  end

  context "validations" do
    it { should validate_presence_of(:total_face_value) }
    it { should validate_presence_of(:advance_amount) }
    it { should validate_presence_of(:discount_fee) }
  end
end

describe Trade do
  describe ".confirmed" do
    it "returns confirmed trades" do
      confirmed_trade = create(:trade, :confirmed)
      unconfirmed_trade = create(:trade)

      trades = Trade.confirmed

      expect(trades).to include confirmed_trade
      expect(trades).not_to include unconfirmed_trade
    end
  end

  describe ".unconfirmed" do
    it "returns unconfirmed trades" do
      confirmed_trade = create(:trade, :confirmed)
      unconfirmed_trade = create(:trade)

      trades = Trade.unconfirmed

      expect(trades).to include unconfirmed_trade
      expect(trades).not_to include confirmed_trade
    end
  end

  describe "#residual" do
    it "calculates the residual amount for a trade" do
      trade = create(:trade,
                     total_face_value: 100_000,
                     advance_amount: 75_000,
                     discount_fee: 1_000)

      residual = trade.residual

      expect(residual).to eq 24_000
    end
  end

  describe "#unfunded?" do
    it "returns true is funding status equals 'Invoices Unfunded'" do
      trade = create(:trade, funding_status: "Invoices Unfunded")
      expect(trade.unfunded?).to eq true
    end

    it "returns false if funding status is not 'Invoices Unfunded'" do
      trade = create(:trade, funding_status: "Invoices Funded")
      expect(trade.unfunded?).to eq false
    end
  end
end
