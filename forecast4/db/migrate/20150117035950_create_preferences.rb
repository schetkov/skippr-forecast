class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.decimal :seller_exchange_fee, default: 0.008
      t.decimal :buyer_exchange_fee, default: 0.008

      t.timestamps
    end
  end
end
