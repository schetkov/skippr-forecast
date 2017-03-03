context.instance_eval do
  panel 'Bank Details' do
    attributes_table_for bank_details do
      row :name
      row :account_name
      row :account_number
      row :bsb_number
    end
  end
end
