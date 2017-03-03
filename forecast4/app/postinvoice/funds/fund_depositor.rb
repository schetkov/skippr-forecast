module Funds
  class FundDepositor
    def initialize(buyer, fund_statement_params = {})
      @fund_statement_params = fund_statement_params
      @buyer = buyer
    end

    def call
      # First time deposit
      if buyer.fund_statements.empty?
        FundStatement.new(new_fund_statement_attributes)
      end
    end

    private

    attr_reader :fund_statement_params, :buyer

    def new_fund_statement_attributes
      fund_statement_params.merge(
        unallocated_cash: fund_statement_params[:total_cash]
      )
    end
  end
end
