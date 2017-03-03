context.instance_eval do
  table_for(existing_facilities, class: 'index_table') do
    column :name
    column :amount
    column :secured
  end
end
