context.instance_eval do
  table_for(invoice.attachments, class: 'index_table') do
    column('File Name') do |ppsr|
      ppsr.file_name.split('/').last.gsub('_', ' ').gsub('.pdf', '').capitalize
    end
    column :created_at
    column :updated_at
    column do |attachment|
      link_to 'View', cl_image_path(attachment.file_name), target: '_blank'
    end
    column do |attachment|
      link_to 'Delete', admin_delete_invoice_ppsr_path(invoice, attachment),
        method: :delete
    end
  end
end
