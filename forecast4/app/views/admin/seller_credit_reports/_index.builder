context.instance_eval do
  table_for(credit_reports, class: 'index_table') do
    column 'Credit Reports' do |attachment|
      link_to 'View File', cl_image_path(attachment.file_name), target: '_blank'
    end
    column :created_at
    column do |attachment|
      link_to 'Delete', admin_seller_credit_reports_path(seller, attachment),
        method: :delete, confirm: 'Are you sure?'
    end
  end
end
