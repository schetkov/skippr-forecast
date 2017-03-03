class CreateMandates < ActiveRecord::Migration
  def change
    create_table :mandates do |t|
      t.decimal :percentage_of_funds_for_investor
      t.decimal :percentage_of_each_invoice
      t.references :debtor, index: true
      t.references :buyer, index: true

      t.timestamps null: false
    end
  end
end
