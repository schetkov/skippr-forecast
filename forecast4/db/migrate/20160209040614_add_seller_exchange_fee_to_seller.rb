class AddSellerExchangeFeeToSeller < ActiveRecord::Migration
  def change
    add_column :sellers, :exchange_fee, :decimal
  end
end
