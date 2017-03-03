context.instance_eval do
  panel "Invoice Rating" do
    attributes_table_for invoice.rating do
      row :discount_rate
      row :advance_amount
      row :master_rating_value
      row :master_rating_applied_at
    end
  end
end
