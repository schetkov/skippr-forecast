require 'rails_helper'

describe BankDetails do
  it 'has a valid factory' do
    expect(build(:bank_details)).to be_valid
  end

  context 'associations' do
    it { should belong_to(:bankable) }
  end

  context 'validations' do
    it { should validate_presence_of(:account_name) }
    it { should validate_presence_of(:account_number) }
    it { should validate_presence_of(:bsb_number) }
  end
end
