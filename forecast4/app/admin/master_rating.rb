ActiveAdmin.register MasterRating do

  permit_params :rating_value, :discount_rate, :advance_amount

  menu priority: 7

  index do
    id_column
    column("Rating") do |rating|
      rating.rating_value
    end
    column :discount_rate
    column :advance_amount
    column :actions do |rating|
      raw( %(#{link_to "View", [:admin, rating]}
             #{link_to "Delete", [:admin, rating], method: :delete }
             #{(link_to"Edit", [:edit, :admin, rating]) }) )
    end
  end
end
