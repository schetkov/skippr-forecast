context.instance_eval do
  table_for(invoice.purchase_order_files, class: 'index_table') do
    column('Purchase Order File') do |purchase_order_file|
      purchase_order_file.file_name.split('/').last.gsub('_', ' ').gsub('.pdf', '').capitalize
    end
    column :created_at
    column :updated_at
    column do |purchase_order_file|
      link_to 'View', cl_image_path(purchase_order_file.file_name), target: '_blank'
    end
    # column do |ppsr|
    #   link_to 'Delete', admin_delete_invoice_ppsr_path(ppsr.invoice, ppsr),
    #     method: :delete
    # end
  end
end
