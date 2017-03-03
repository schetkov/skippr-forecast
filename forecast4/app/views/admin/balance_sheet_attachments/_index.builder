context.instance_eval do
  table_for(balance_sheet_attachments, class: 'index_table') do
    column 'Balance Sheet Attachments' do |attachment|
      link_to 'View File', cl_image_path(attachment.file_name), target: '_blank'
    end
    column :created_at
    # TODO
    # column do |attachment|
    #   link_to 'Delete', admin_seller_balance_sheet_attachment_path(attachment.seller, attachment),
    #     method: :delete, confirm: 'Are you sure?'
    # end
  end
end
