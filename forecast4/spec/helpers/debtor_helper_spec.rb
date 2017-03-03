require "rails_helper"

describe DebtorHelper do
  describe "#sum_of_oustanding_aged_receivables" do
    it "displays the sum of all outstanding aged receivables for a debtor" do
      debtor = create(:debtor,
                      thirty_days: 20000,
                      sixty_days: 20000,
                      ninety_days: 20000,
                      over_ninety_days: 20000)

      sum = helper.sum_of_oustanding_aged_receivables(debtor)

      expect(sum).to eq 80000
    end
  end

  describe "#last_updated_date_for_aged_receivables" do
    it "displays the date for it last updated aged receivables data" do
      debtor = create(
        :debtor,
        aged_receivables_last_updated_at: DateTime.new(2015, 8, 8)
      )

      date = helper.last_updated_date_for_aged_receivables(debtor)

      expect(date).to eq "(Last updated at: 8 August 2015)"
    end

    it "doesn't display anything if date is nil" do
      debtor = create(:debtor, aged_receivables_last_updated_at: nil)

      date = helper.last_updated_date_for_aged_receivables(debtor)

      expect(date).to eq ""
    end
  end
end
