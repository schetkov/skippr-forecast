context.instance_eval do
  table_for(aged_payable_reports, class: 'index_table') do
    column 'Aged Payable Reports' do |attachment|
      link_to 'View File', cl_image_path(attachment.file_name), target: '_blank'
    end
    column :created_at
    # column do |attachment|
    #   link_to 'Delete', admin_seller_aged_payable_reports_path(attachment.seller, attachment),
    #     method: :delete, confirm: 'Are you sure?'
    # end
  end
end
