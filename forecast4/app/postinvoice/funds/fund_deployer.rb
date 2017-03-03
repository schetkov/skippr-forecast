module Funds
  class FundDeployer
    def initialize(invoices, fund_deployer = Funds::BuyerFundDeployer)
      @invoices = invoices
      @fund_deployer = fund_deployer
    end

    def call
      invoices.each do |invoice|
        fund_deployer.new(invoice).call
      end
    end

    private

    attr_reader :invoices, :fund_deployer
  end
end
