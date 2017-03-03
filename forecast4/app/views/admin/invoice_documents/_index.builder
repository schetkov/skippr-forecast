context.instance_eval do
  table_for(invoice_documents, class: 'index_table') do
    column 'Invoice Documents' do |attachment|
      link_to 'View File', cl_image_path(attachment.file_name), target: '_blank'
    end
    column :created_at
  end
end
