module BuyerHelper
  def buyer_has_sufficient_funds?(buyer, invoice)
    buyer.latest_fund_statement.unallocated_cash > invoice.advance_amount_in_dollars
  end

  def buyers_allocated_cash_for_debtor(buyer, debtor)
    invoices = buyer.invoices.where(debtor: debtor, workflow_state: ["approved", "sold"])
    invoices.inject(0) do |result, invoice|
      result += invoice.advance_amount_in_dollars
      result
    end
  end

  def buyers_funds_deployed_for_debtor(buyer, debtor)
    invoices = buyer.invoices.where(debtor: debtor, workflow_state: "funded")
    invoices.inject(0) do |result, invoice|
      result += invoice.advance_amount_in_dollars
      result
    end
  end

  def buyers_current_exposure_for_debtor(buyer, debtor)
    invoices = buyer.invoices.where(debtor: debtor, workflow_state: ["approved", "sold", "funded"])
    invoices.inject(0) do |result, invoice|
      result += invoice.advance_amount_in_dollars
      result
    end
  end
end
