class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string   "legal_business_name"
      t.string   "address"
      t.string   "acn"
      t.string   "website",                          default: ""
      t.string   "business_type"
      t.string   "business_sector"
      t.string   "contact_name"
      t.string   "contact_phone_number"
      t.string   "internal_account_debtor_id"
      t.string   "customer_reference_id"
      t.string   "payment_processor"
      t.string   "other_name"
      t.integer  "thirty_days",                      default: 0
      t.integer  "sixty_days",                       default: 0
      t.integer  "ninety_days",                      default: 0
      t.integer  "over_ninety_days",                 default: 0
      t.string   "warranties"
      t.string   "progressive_billing"
      t.string   "return_rights"
      t.string   "consignment_basis"
      t.text     "credit_terms"
      t.date     "relationship_start_date"
      t.integer  "status",                           default: 0
      t.integer  "seller_id"
      t.integer  "seller_company_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "discounts_offered"
      t.string   "allow_offsets",                    default: "no"
      t.string   "contact_email"
      t.string   "contact_id"
      t.string   "contact_status"
      t.string   "account_number"
      t.string   "tax_number"
      t.json     "addresses"
      t.json     "phones"
      t.datetime "aged_receivables_last_updated_at"
      t.string   "value_of_outstanding_invoices"
    end
  end
end
