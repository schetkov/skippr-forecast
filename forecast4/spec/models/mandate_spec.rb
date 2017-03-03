require 'rails_helper'

describe Mandate do
  it "has a valid factory" do
    expect(create(:mandate)).to be_valid
  end

  context "associations" do
    it { should belong_to(:debtor) }
    it { should belong_to(:buyer) }
  end
end
