context.instance_eval do
  panel "Accountant's Details" do
    attributes_table_for accountant do
      row :name
      row :email
      row :phone_number
      row("Letter") do |accountant|
        if accountant.buyer_company.buyer.letter_from_accountant
          link_to 'View', cl_image_path(accountant.buyer_company.buyer.letter_from_accountant.file_id), target: '_blank'
        end
      end
      row :buyer
      row :created_at
      row :updated_at
    end
  end
end
