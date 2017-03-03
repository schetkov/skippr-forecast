context.instance_eval do
  table_for(misc_documents, class: 'index_table') do
    column 'Other Supporting Documents (Customer Ledger)' do |attachment|
      link_to 'View File', cl_image_path(attachment.file_name), target: '_blank'
    end
    column :created_at
  end
end
