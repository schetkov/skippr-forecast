context.instance_eval do
  panel "AFSL" do
    attributes_table_for afsl do
      row("AFSL Number") { |i| i.attachable.buyer_company.afsl_number }
      row :file_id do |i|
        link_to 'View', cl_image_path(i.file_id), target: '_blank'
      end
      row('Buyer') { |i| i.attachable }
      row :created_at
      row :updated_at
    end
  end
end
