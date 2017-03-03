context.instance_eval do
  panel "Fees" do
    attributes_table_for invoice do
      row("Advance Amount") do
        if invoice.rating
          number_to_currency(invoice.advance_amount_in_dollars, precision: 2)
        else
          "Invoice hasn't been rated"
        end
      end
      row("Net Advance Amount") do
        if invoice.rating
          number_to_currency(invoice.net_advance_amount, precision: 2)
        else
          "Invoice hasn't been rated"
        end
      end
      row("Discount Fee") do
        if invoice.rating && invoice.paid_on && invoice.funded_on
           number_to_currency(invoice.discount_fee_in_dollars, precision: 2)
        elsif invoice.rating && invoice.trade && invoice.funded_on
          "ESTIMATED DISCOUNT FEE (based on todays date): \
          #{number_to_currency(invoice.todays_discount_fee_in_dollars, precision: 2)}"
        else
          "Invoice either hasn't been rated, paid or funded"
        end
      end
      row("Seller Exchange Fee") do
        number_to_currency(invoice.seller_exchange_fee, precision: 2)
      end

      row("Buyer Exchange Fee") do
        number_to_currency(invoice.buyer_exchange_fee, precision: 2)
      end
    end
  end
end
