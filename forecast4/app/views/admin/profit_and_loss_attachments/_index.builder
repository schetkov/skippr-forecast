context.instance_eval do
  table_for(profit_and_loss_attachments, class: 'index_table') do
    column 'Profit And Loss Attachments' do |attachment|
      link_to 'View File', cl_image_path(attachment.file_name), target: '_blank'
    end
    column :created_at
    # column do |attachment|
    #   link_to 'Delete', admin_seller_profit_and_loss_attachment_path(attachment.seller, attachment),
    #     method: :delete, confirm: 'Are you sure?'
    # end
  end
end
