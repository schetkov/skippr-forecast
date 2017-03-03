context.instance_eval do
  panel 'Financials' do
    attributes_table_for financials do
      row :net_revenues do |i|
        number_to_currency(i.net_revenues, precision: 0)
      end
      row :gross_profit_margin do |i|
        number_to_currency(i.gross_profit_margin, precision: 0)
      end
      row :last_reported_trade_debtors do |i|
        number_to_currency(i.last_reported_trade_debtors, precision: 0)
      end
      row :last_reported_trade_creditors do |i|
        number_to_currency(i.last_reported_trade_creditors, precision: 0)
      end
      row :loans_outstanding do |i|
        number_to_currency(i.loans_outstanding, precision: 0)
      end
      row :liability_outstanding do |i|
        number_to_currency(i.liability_outstanding, precision: 0)
      end
    end
  end
end
