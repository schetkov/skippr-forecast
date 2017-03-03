context.instance_eval do
  table_for(debtor.customer_receipts, class: 'index_table') do
    column('Customer Receipts (Debtor Trade Payments History)') do |customer_receipt|
      customer_receipt.file_name.split('/').last.gsub('_', ' ').gsub('.pdf', '').capitalize
    end
    column :created_at
    column :updated_at
    column do |customer_receipt|
      link_to 'View', cl_image_path(customer_receipt.file_name), target: '_blank'
    end
  end
end
