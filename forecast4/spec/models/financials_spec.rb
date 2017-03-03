require 'rails_helper'

describe Financials do
  it 'has a valid factory' do
    expect(build(:financials)).to be_valid
  end

  context 'associations' do
    it { should belong_to(:seller_company) }
  end

  context 'validations' do
    it { should validate_presence_of(:net_revenues) }
    it { should validate_presence_of(:gross_profit_margin) }
    it { should validate_presence_of(:last_reported_trade_debtors) }
    it { should validate_presence_of(:last_reported_trade_creditors) }
    it { should validate_presence_of(:loans_outstanding) }
    it { should validate_presence_of(:liability_outstanding) }
  end
end
