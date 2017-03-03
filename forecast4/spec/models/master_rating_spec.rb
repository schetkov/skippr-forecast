require 'rails_helper'

describe MasterRating do
  it "has a valid factory" do
    expect(create(:master_rating)).to be_valid
  end

  context "validations" do
    it { should validate_presence_of(:rating_value) }
    it { should validate_presence_of(:discount_rate) }
    it { should validate_presence_of(:advance_amount) }
  end
end
