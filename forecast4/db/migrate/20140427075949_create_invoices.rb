class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :invoice_no
      t.integer :face_value
      t.string :purchase_order_number
      t.date :date
      t.date :due_date
      t.date :anticipated_pay_date
      t.date :merchandise_shipped_on
      t.date :merchandise_arrived_on
      t.string :shipping_company_url
      t.string :tracking_code
      t.date :services_started_on
      t.date :services_ended_on
      t.text :services_description
      t.string :discounts_offered
      t.integer :status, default: 0
      t.string :funding_status
      t.boolean :service_rendered, default: false
      t.boolean :customer_satisfied, default: false
      t.boolean :payment_to_be_sent, default: false
      t.references :seller
      t.references :debtor

      t.timestamps
    end
  end
end
