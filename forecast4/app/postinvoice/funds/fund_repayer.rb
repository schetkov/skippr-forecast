module Funds
  class FundRepayer
    def initialize(invoice)
      @invoice = invoice
      @buyer = invoice.buyer
    end

    def call
      buyer.fund_statements.create(
        funds_deployed: funds_deployed,
        total_cash: total_cash,
        allocated_cash: allocated_cash,
        unallocated_cash: unallocated_cash,
        note: note
      )
    end

    private

    attr_reader :invoice, :buyer

    def funds_deployed
      buyers_latest_fund_statement.funds_deployed -
        invoice.advance_amount_in_dollars
    end

    def total_cash
      buyers_latest_fund_statement.total_cash + repayment_amount
    end

    def allocated_cash
      buyers_latest_fund_statement.allocated_cash
    end

    def unallocated_cash
      buyers_latest_fund_statement.total_cash + repayment_amount
    end

    def note
      "$#{repayment_amount} repaid for invoice ##{invoice.id}"
    end

    def repayment_amount
      (invoice.advance_amount_in_dollars + invoice.discount_fee_in_dollars).ceil
    end

    def buyers_latest_fund_statement
      @fund_statement ||= buyer.latest_fund_statement
    end
  end
end
