class CreateFinancials < ActiveRecord::Migration
  def change
    create_table :financials do |t|
      t.integer :net_revenues
      t.integer :current_assets
      t.integer :total_assets
      t.integer :current_liabilities
      t.integer :total_liabilities
      t.integer :retained_earnings
      t.references :seller_company

      t.timestamps
    end
  end
end
