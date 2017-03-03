class CreateExistingFacilities < ActiveRecord::Migration
  def change
    create_table :existing_facilities do |t|
      t.string :name
      t.string :amount
      t.string :secured, default: "Secured"
      t.references :seller_company

      t.timestamps null: false
    end
  end
end
