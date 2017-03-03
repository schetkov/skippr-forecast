require 'rails_helper'

describe Rating do
  it "has a valid factory" do
    expect(create(:rating)).to be_valid
  end

  context "associations" do
    it { should belong_to(:invoice) }
  end

  context "validations" do
    it { should validate_presence_of(:master_rating_value) }
    it { should validate_presence_of(:discount_rate) }
    it { should validate_presence_of(:advance_amount) }
    it { should validate_presence_of(:master_rating_applied_at) }
  end
end
