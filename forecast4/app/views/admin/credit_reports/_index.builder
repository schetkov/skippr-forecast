context.instance_eval do
  table_for(debtor.credit_reports, class: 'index_table') do
    column('Credit Reports') do |cr|
      cr.file_name.split('/').last.gsub('_', ' ').gsub('.pdf', '').capitalize
    end
    column :created_at
    column :updated_at
    column do |cr|
      link_to 'View', cl_image_path(cr.file_name), target: '_blank'
    end
    # column do |cr|
    #   link_to 'Delete', admin_delete_debtor_credit_report_path(cr.reportable, cr),
    #     method: :delete
    # end
  end
end
