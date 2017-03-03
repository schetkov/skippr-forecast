context.instance_eval do
  panel 'Debtor Terms' do
    attributes_table_for debtor_terms do
      row('Does seller offer warranties?') do |i|
        i.warranties.capitalize
      end
      row('Does seller ever bill on a progressive basis?') do |i|
        i.progressive_billing.capitalize
      end
      row('Does seller offer return rights?') do |i|
        i.return_rights.capitalize
      end
      row('Does seller sell on consigment basis?') do |i|
        i.consignment_basis.capitalize
      end
      row('Does seller offer any discounts?') do |i|
        i.discounts.capitalize
      end
      row('allow offsets') do |i|
        i.allow_offsets.capitalize
      end
    end
  end
end
