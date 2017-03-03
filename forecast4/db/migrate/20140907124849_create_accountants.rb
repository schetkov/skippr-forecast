class CreateAccountants < ActiveRecord::Migration
  def change
    create_table :accountants do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :file_id
      t.references :buyer_company

      t.timestamps
    end
  end
end
