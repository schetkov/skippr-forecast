require 'rails_helper'

describe FundStatement do
  it "has a valid factory" do
    expect(create(:fund_statement)).to be_valid
  end

  context "associations" do
    it { should belong_to(:buyer) }
  end
end
