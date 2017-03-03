class CreatePayables < ActiveRecord::Migration
  def change
    create_table :payables do |t|
      t.string   "invoice_no"
      t.decimal  "face_value",                       default: 0.0
      t.string   "purchase_order_number"
      t.date     "date"
      t.date     "due_date"
      t.date     "anticipated_pay_date"
      t.integer  "seller_id", index: true
      t.integer  "debtor_id", index: true
      t.date     "paid_on"
      t.string   "invoice_xero_id"
      t.string   "invoice_contact_id"
      t.string   "reference"
      t.string   "xero_type"
      t.string   "xero_status"
      t.decimal  "total_tax"
      t.decimal  "sub_total"
      t.decimal  "amount_due"
      t.decimal  "amount_paid"
      t.decimal  "amount_credited"
      t.datetime "updated_date_utc"
      t.string   "currency_code"
      t.decimal  "currency_rate"

      t.timestamps
    end
  end
end
