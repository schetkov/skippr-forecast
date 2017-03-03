require 'rails_helper'

describe Accountant do
  it 'has a valid factory' do
    expect(build(:accountant)).to be_valid
  end

  context 'associations' do
    it { should belong_to(:buyer_company) }
  end
end
