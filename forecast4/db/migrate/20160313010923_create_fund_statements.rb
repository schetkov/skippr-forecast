class CreateFundStatements < ActiveRecord::Migration
  def change
    create_table :fund_statements do |t|
      t.decimal :total_cash, default: 0
      t.decimal :unallocated_cash, default: 0
      t.decimal :allocated_cash, default: 0
      t.decimal :funds_deployed, default: 0
      t.string :note
      t.references :buyer, index: true

      t.timestamps null: false
    end
  end
end
