class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.integer :total_face_value, null: false
      t.decimal :advance_amount, null: false
      t.decimal :net_advance_amount
      t.decimal :discount_fee, null: false
      t.date :funded_on
      t.string :funding_status, default: "Invoices Unfunded"
      t.datetime :confirmed_at
      t.decimal :seller_exchange_fee
      t.decimal :buyer_exchange_fee
      t.references :seller, null: false
      t.references :buyer, null: false

      t.timestamps null: false
    end
  end
end
