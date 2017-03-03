context.instance_eval do
  attributes_table do
    row :total_face_value
    row :advance_amount
    row :net_advance_amount
    row :discount_fee
    row :seller_exchange_fee
    row :buyer_exchange_fee
    row :funded_on
    row :funding_status
    row :confirmed_at
    row :seller
    row :buyer
    row :created_at
    row :updated_at
  end

  render "admin/invoices/index", invoices: trade.invoices, context: self
end
