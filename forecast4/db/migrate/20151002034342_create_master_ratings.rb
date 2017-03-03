class CreateMasterRatings < ActiveRecord::Migration
  def change
    create_table :master_ratings do |t|
      t.string :rating_value
      t.decimal :discount_rate, null: false
      t.decimal :advance_amount, null: false

      t.timestamps null: false
    end
  end
end
