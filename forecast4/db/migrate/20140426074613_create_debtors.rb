class CreateDebtors < ActiveRecord::Migration
  def change
    create_table :debtors do |t|
      t.string :legal_business_name
      t.string :address
      t.string :phone_number
      t.string :acn
      t.string :website, default: ''
      t.string :business_type
      t.string :business_sector
      t.string :contact_name
      t.string :contact_phone_number
      t.string :internal_account_debtor_id
      t.string :customer_reference_id
      t.string :payment_processor
      t.string :other_name
      t.integer :thirty_days, default: 0
      t.integer :sixty_days, default: 0
      t.integer :ninety_days, default: 0
      t.integer :over_ninety_days, default: 0
      t.string :warranties
      t.string :progressive_billing
      t.string :return_rights
      t.string :consignment_basis
      t.text :credit_terms
      t.date :relationship_start_date
      t.integer :status, default: 0
      t.references :seller
      t.references :seller_company

      t.timestamps
    end
  end
end
