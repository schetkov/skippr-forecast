require 'rails_helper'

describe ExistingFacility do
  context "associations" do
    it { should belong_to(:seller_company) }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:amount) }
  end
end
