class CreateDebtorTerms < ActiveRecord::Migration
  def change
    create_table :debtor_terms do |t|
      t.string :warranties
      t.string :progressive_billing
      t.string :return_rights
      t.string :consignment_basis
      t.string :discounts
      t.string :allow_offsets
      t.references :seller_company

      t.timestamps
    end
  end
end
