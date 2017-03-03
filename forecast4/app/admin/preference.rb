ActiveAdmin.register Preference do

  config.filters = false

  menu label: "Settings"

  permit_params :seller_exchange_fee, :buyer_exchange_fee
end
