ActiveAdmin.register Trade do

  form partial: "form"

  menu priority: 4

  scope :all
  scope :unconfirmed
  scope :confirmed

  permit_params :total_face_value,
                :advance_amount,
                :net_advance_amount,
                :discount_fee,
                :funded_on,
                :funding_status,
                :confirmed_at

  index do
    id_column
    column :total_face_value
    column :advance_amount
    column :net_advance_amount
    column :discount_fee
    column :confirmed_at
    column :actions do |trade|
      raw( %(#{link_to "View", [:admin, trade]}
             #{link_to "Delete", [:admin, trade], method: :delete }
             #{(link_to"Edit", [:edit, :admin, trade]) }) )
    end
  end

  show title: :id do
    render "show", context: self
  end
end
