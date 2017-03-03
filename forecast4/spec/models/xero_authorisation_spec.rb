require 'rails_helper'

describe XeroAuthorisation do
  it "has  valid factory" do
    expect(create(:xero_authorisation)).to be_valid
  end

  context "associations" do
    it { should belong_to(:seller) }
  end
end
