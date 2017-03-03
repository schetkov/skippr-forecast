require 'rails_helper'

describe CashFlowRule do
  it 'has a valid factory' do
    expect(build(:cash_flow_rule)).to be_valid
  end
end


