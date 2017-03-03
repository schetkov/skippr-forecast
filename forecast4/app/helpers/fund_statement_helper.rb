module FundStatementHelper
  def cash_earmarked(fund_statement, invoice)
    cash_to_be_earmarked = invoice.advance_amount_in_dollars
    if fund_statement.unallocated_cash > cash_to_be_earmarked
      invoice.advance_amount_in_dollars
    else
      0
    end
  end

  def closing_unallocated_cash(fund_statement, invoice)
    closing_unallocated_cash =
      fund_statement.unallocated_cash - invoice.advance_amount_in_dollars
    if closing_unallocated_cash > 0
      closing_unallocated_cash
    else
      0
    end
  end
end
