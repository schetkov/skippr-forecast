require 'rails_helper'

describe Payable do
  it 'has a valid factory' do
    expect(build(:payable)).to be_valid
  end

  context "associations" do
    it { should have_many(:attachments) }
    #it { should have_one(:rating) }
    it { should belong_to(:debtor) }
    it { should belong_to(:seller) }
    #it { should belong_to(:trade) }
  end

  context "validations" do
    it { should validate_presence_of(:face_value) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:due_date) }
    it { should validate_uniqueness_of(:invoice_xero_id) }
  end
end
