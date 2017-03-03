require "rails_helper"

describe InvoiceHelper do
  describe "#discount_rate_for_invoice_with_trade" do
    it "calculates discount rate assuming the trade was funded on same day" do
      travel_to Time.new(2015, 11, 1).in_time_zone do
        trade = create(:trade, funded_on: nil)
        invoice = create(:invoice,
                         anticipated_pay_date: Date.new(2015, 11, 11),
                         due_date: Date.new(2015, 11, 11),
                         trade: trade)
        create(:rating,
               discount_rate: 0.01,
               invoice: invoice)

        discount_rate = helper.discount_rate_for_invoice_with_trade(invoice)

        expect(discount_rate.round(2)).to eq 0.33
      end
    end
  end

  describe "#payment_period" do
    it "calculates the payment period with a paid invoice" do
      travel_to Time.new(2015, 11, 1).in_time_zone do
        trade = create(:trade, funded_on: Time.zone.today)
        invoice = create(:invoice,
                         due_date: Date.new(2015, 11, 11),
                         paid_on: Date.new(2015, 11, 11),
                         trade: trade)
        create(:rating, invoice: invoice)

        payment_period = helper.payment_period(invoice)

        expect(payment_period).to eq 10
      end
    end

    it "calculates the payment period based on anticipated pay date and trade created_at" do
      travel_to Time.new(2015, 11, 1).in_time_zone do
        trade = create(:trade, funded_on: nil)
        invoice = create(:invoice,
                         paid_on: nil,
                         due_date: Date.new(2015, 11, 11),
                         anticipated_pay_date: Date.new(2015, 11, 11),
                         trade: trade)
        create(:rating, invoice: invoice)

        payment_period = helper.payment_period(invoice)

        expect(payment_period).to eq 10
      end
    end
  end
end
