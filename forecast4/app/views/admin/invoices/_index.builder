context.instance_eval do
  panel 'Invoices' do
    attributes_table_for invoices do
      row :face_value
      row :invoice_no
      row :purchase_order_number
      row :date
      row :due_date
      row :anticipated_pay_date
      row :description
      row :auction
      row :seller
      row :debtor
      row('View Invoice') do |invoice|
        link_to 'View Invoice', admin_invoice_path(invoice)
      end
    end
  end
end
