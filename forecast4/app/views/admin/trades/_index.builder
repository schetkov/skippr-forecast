context.instance_eval do
  panel 'Trades' do
    table_for trades  do
      column :total_face_value
      column :advance_amount
      column :net_advance_amount
      column :discount_fee
      column :seller
      column :funded_on
      column :funded_status
      column :created_at
    end
  end
end
