context.instance_eval do
  table_for(financial_statements, class: 'index_table') do
    column 'Financial Statements' do |attachment|
      link_to 'View File', cl_image_path(attachment.file_name), target: '_blank'
    end
    column :created_at
  end
end
