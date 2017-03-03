require 'rails_helper'

describe DebtorTerms do
  it 'has a valid factory' do
    expect(build(:debtor_terms)).to be_valid
  end

  context 'associations' do
    it { should belong_to(:seller_company) }
  end

  context 'validations' do
    it { should validate_presence_of(:warranties) }
    it { should validate_presence_of(:progressive_billing) }
    it { should validate_presence_of(:return_rights) }
    it { should validate_presence_of(:consignment_basis) }
    it { should validate_presence_of(:discounts) }
  end
end
