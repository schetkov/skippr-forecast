require "rails_helper"

describe Debtors::AgedReceivablesCalculator do

  context "constants" do
    it "should store magic numbers (invoice payment periods in constants" do
      expect(Debtors::AgedReceivablesCalculator::THIRTY_DAYS).to eq 30
      expect(Debtors::AgedReceivablesCalculator::SIXTY_DAYS).to eq 60
      expect(Debtors::AgedReceivablesCalculator::NINETY_DAYS).to eq 90
    end
  end

  it "calculates aged receivables based on the data from Xero" do
    travel_to Time.new(2015, 8, 20) do
      xero_report = double("xero report", get: FakeAgedReceivablesReport.new)
      fake_xero = double("xero client", "AgedReceivablesByContact": xero_report)
      debtor = create(:debtor,
                      contact_id: "123",
                      thirty_days: 0,
                      sixty_days: 0,
                      ninety_days: 0,
                      over_ninety_days: 0)

      Debtors::AgedReceivablesCalculator.new(fake_xero, debtor).call

      expect(debtor.thirty_days).to eq 15000
      expect(debtor.sixty_days).to eq 0
      expect(debtor.ninety_days).to eq 20000
      expect(debtor.over_ninety_days).to eq 0
      expect(debtor.aged_receivables_last_updated_at).not_to eq nil
    end
  end
end
