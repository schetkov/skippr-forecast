class CreateBuyers < ActiveRecord::Migration
  def change
    create_table :buyers do |t|
      t.integer :status, default: 0
      t.string :investor_type
      t.references :user

      t.timestamps
    end
  end
end
