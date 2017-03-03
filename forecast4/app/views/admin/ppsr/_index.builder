context.instance_eval do
  table_for(invoice.ppsrs, class: 'index_table') do
    column('PPSR') do |ppsr|
      ppsr.file_name.split('/').last.gsub('_', ' ').gsub('.pdf', '').capitalize
    end
    column :created_at
    column :updated_at
    column do |ppsr|
      link_to 'View', cl_image_path(ppsr.file_name), target: '_blank'
    end
    column do |ppsr|
      link_to 'Delete', admin_delete_invoice_ppsr_path(invoice, ppsr),
        method: :delete
    end
  end
end
