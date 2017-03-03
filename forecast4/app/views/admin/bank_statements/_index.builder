context.instance_eval do
  table_for(bank_statements, class: 'index_table') do
    column 'Bank Statements' do |attachment|
      link_to 'View File', cl_image_path(attachment.file_name), target: '_blank'
    end
    column :created_at
  end
end
