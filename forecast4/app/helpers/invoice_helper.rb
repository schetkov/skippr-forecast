module InvoiceHelper
  def discount_rate_for_invoice_with_trade(invoice)
    invoice.rating.discount_rate * (payment_period(invoice) / 30.00) * 100
  end

  def payment_period(invoice)
    if invoice.paid_on
      (invoice.paid_on - invoice.trade.funded_on).to_i
    elsif invoice.anticipated_pay_date && invoice.trade
      (invoice.anticipated_pay_date - invoice.trade.created_at.to_date).to_i
    elsif invoice.trade
      (invoice.due_date - invoice.trade.created_at.to_date).to_i
    else
      (invoice.due_date - invoice.date).to_i
    end
  end
end
