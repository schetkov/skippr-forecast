require "rails_helper"

describe Invoices::RatingApplier do
  it "creates an invoice rating based on the rating value passed in" do
    create(:master_rating,
           rating_value: "1",
           discount_rate: 0.05,
           advance_amount: 0.85)
    invoice = create(:invoice)
    rating_value = "1"

    Invoices::RatingApplier.new(invoice, rating_value).call

    expect(invoice.rating_value).to eq "1"
    expect(invoice.rating.master_rating_value).to eq "1"
    expect(invoice.rating.discount_rate).to eq 0.05
    expect(invoice.rating.advance_amount).to eq 0.85
    expect(invoice.rating.master_rating_applied_at).not_to eq nil
  end

  it "doesn't create an invoice rating if the rating value is not present" do
    create(:master_rating,
           rating_value: "1",
           discount_rate: 0.05,
           advance_amount: 0.85)
    invoice = create(:invoice)
    rating_value = nil

    Invoices::RatingApplier.new(invoice, rating_value).call

    expect(invoice.rating).to eq nil
  end
end
