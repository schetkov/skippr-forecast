module Funds
  class FundAllocator
    def initialize(buyer, invoice)
      @buyer = buyer
      @invoice = invoice
    end

    def call
      buyer.fund_statements.create(
        total_cash: total_cash,
        allocated_cash: allocated_cash,
        unallocated_cash: unallocated_cash,
        funds_deployed: funds_deployed,
        note: note
      )
    end

    private

    attr_reader :buyer, :invoice

    def total_cash
      buyers_latest_fund_statement.total_cash
    end

    def allocated_cash
      buyers_latest_fund_statement.allocated_cash +
        invoice.advance_amount_in_dollars
    end

    def unallocated_cash
      buyers_latest_fund_statement.unallocated_cash -
        invoice.advance_amount_in_dollars
    end

    def funds_deployed
      buyers_latest_fund_statement.funds_deployed
    end

    def note
      "$#{invoice.advance_amount_in_dollars.ceil} " \
      "allocated to invoice ##{invoice.id}"
    end

    def buyers_latest_fund_statement
      @fund_statement ||= buyer.latest_fund_statement
    end
  end
end
