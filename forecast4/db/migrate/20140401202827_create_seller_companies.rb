class CreateSellerCompanies < ActiveRecord::Migration
  def change
    create_table :seller_companies  do |t|
      t.string :name
      t.integer :years_in_business
      t.string :address
      t.string :phone_number
      t.string :website
      t.string :acn
      t.string :abn
      t.text :description
      t.string :principal_business_owner
      t.string :principal_ownership
      t.string :other_registered_name
      t.string :avatar_id
      t.string :industry
      t.datetime :approved
      t.references :seller
      t.timestamps null: false
    end
  end
end
