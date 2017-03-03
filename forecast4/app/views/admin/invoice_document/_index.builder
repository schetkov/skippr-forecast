context.instance_eval do
  table_for(invoice.invoice_document, class: 'index_table') do
    column('Invoice Document') do |invoice_document|
      invoice_document.file_name.split('/').last.gsub('_', ' ').gsub('.pdf', '').capitalize
    end
    column :created_at
    column :updated_at
    column do |invoice_document|
      link_to 'View', cl_image_path(invoice_document.file_name), target: '_blank'
    end
    # column do |ppsr|
    #   link_to 'Delete', admin_delete_invoice_ppsr_path(ppsr.invoice, ppsr),
    #     method: :delete
    # end
  end
end
