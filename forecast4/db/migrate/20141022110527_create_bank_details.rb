class CreateBankDetails < ActiveRecord::Migration
  def change
    create_table :bank_details do |t|
      t.string :name
      t.string :account_name
      t.string :account_number
      t.references :bankable, polymorphic: true

      t.timestamps
    end
  end
end
