context.instance_eval do
  table_for(invoice.notice_of_assignments, class: 'index_table') do
    column('Notice of Assignment') do |ppsr|
      ppsr.file_name.split('/').last.gsub('_', ' ').gsub('.pdf', '').capitalize
    end
    column :created_at
    column :updated_at
    column do |file|
      link_to 'View', cl_image_path(file.file_name), target: '_blank'
    end
    column do |file|
      link_to 'Delete', admin_invoice_notice_of_assignment_path(invoice, file),
        method: :delete
    end
  end
end
