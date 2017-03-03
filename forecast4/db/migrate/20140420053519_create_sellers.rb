class CreateSellers < ActiveRecord::Migration
  def change
    create_table :sellers do |t|
      t.integer :status, default: 0
      t.references :user

      t.timestamps
    end
  end
end
