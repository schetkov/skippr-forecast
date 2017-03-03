context.instance_eval do
  table_for(debtor.sales_agreements, class: 'index_table') do
    column('Sales Agreements') do |sales_agreement|
      sales_agreement.file_name.split('/').last.gsub('_', ' ').gsub('.pdf', '').capitalize
    end
    column :created_at
    column :updated_at
    column do |sales_agreement|
      link_to 'View', cl_image_path(sales_agreement.file_name), target: '_blank'
    end
    column do |sales_agreement|
      link_to 'Delete', admin_delete_debtor_sales_agreement_path(sales_agreement.attachable, sales_agreement),
        method: :delete
    end
  end
end
