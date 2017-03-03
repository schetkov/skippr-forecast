class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.string :master_rating_value, null: false
      t.decimal :discount_rate, null: false
      t.decimal :advance_amount, null: false
      t.datetime :master_rating_applied_at, null: false
      t.references :invoice, null: false

      t.timestamps null: false
    end
  end
end
