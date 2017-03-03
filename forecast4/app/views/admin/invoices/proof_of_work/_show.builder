context.instance_eval do
  panel 'Proof of work' do
    attributes_table_for invoice do
      row :merchandise_shipped_on
      row :merchandise_arrived_on
      row :shipping_company_url
      row :tracking_code
      row :services_started_on
      row :services_ended_on
      row :services_description
    end
  end
end
