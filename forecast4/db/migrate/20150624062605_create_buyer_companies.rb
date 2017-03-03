class CreateBuyerCompanies < ActiveRecord::Migration
  def change
    create_table :buyer_companies do |t|
      t.string :name
      t.string :acn
      t.string :abn
      t.string :website
      t.string :phone_number
      t.text :description
      t.datetime :approved
      t.string :name
      t.string :afsl_number
      t.string :avatar_id
      t.references :buyer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
