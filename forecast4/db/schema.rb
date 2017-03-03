# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160513105002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accountants", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "file_id"
    t.integer  "buyer_company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.string   "file_id"
    t.string   "file_name"
    t.integer  "file_type"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "bank_details", force: :cascade do |t|
    t.string   "account_name"
    t.string   "account_number"
    t.integer  "bankable_id"
    t.string   "bankable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bsb_number"
  end

  create_table "buyer_companies", force: :cascade do |t|
    t.string   "name"
    t.string   "acn"
    t.string   "abn"
    t.string   "website"
    t.string   "phone_number"
    t.text     "description"
    t.datetime "approved"
    t.string   "afsl_number"
    t.string   "avatar_id"
    t.integer  "buyer_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "buyer_companies", ["buyer_id"], name: "index_buyer_companies_on_buyer_id", using: :btree

  create_table "buyers", force: :cascade do |t|
    t.string   "investor_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "workflow_state"
  end

  create_table "cash_flow_rules", force: :cascade do |t|
    t.integer "cash_flow_scenario_id"
    t.integer "seller_id"
    t.integer "debtor_id"
    t.string  "rule_type"
    t.string  "reference"
    t.decimal "amount",                precision: 10, scale: 2
    t.string  "currency_code"
    t.integer "interval",                                       default: 1
    t.integer "terms"
    t.date    "due_date"
    t.date    "created_at"
    t.date    "updated_at"
    t.integer "vendor_id"
    t.boolean "is_clone"
    t.boolean "is_hidden"
    t.integer "parent_id"
    t.date    "initial_date"
    t.boolean "is_sold"
    t.string  "other_expenses_name"
    t.boolean "reccuring"
  end

  create_table "cash_flow_scenarios", force: :cascade do |t|
    t.integer  "seller_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_receipts", force: :cascade do |t|
    t.string   "file_id"
    t.string   "file_name"
    t.integer  "debtor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debtor_terms", force: :cascade do |t|
    t.string   "warranties"
    t.string   "progressive_billing"
    t.string   "return_rights"
    t.string   "consignment_basis"
    t.string   "discounts"
    t.string   "allow_offsets"
    t.integer  "seller_company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debtors", force: :cascade do |t|
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

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "existing_facilities", force: :cascade do |t|
    t.string   "name"
    t.string   "amount"
    t.string   "secured",           default: "Secured"
    t.integer  "seller_company_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "financials", force: :cascade do |t|
    t.integer  "net_revenues"
    t.integer  "gross_profit_margin"
    t.integer  "last_reported_trade_debtors"
    t.integer  "last_reported_trade_creditors"
    t.integer  "loans_outstanding"
    t.integer  "liability_outstanding"
    t.integer  "seller_company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fund_statements", force: :cascade do |t|
    t.decimal  "total_cash",       default: 0.0
    t.decimal  "unallocated_cash", default: 0.0
    t.decimal  "allocated_cash",   default: 0.0
    t.decimal  "funds_deployed",   default: 0.0
    t.string   "note"
    t.integer  "buyer_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "fund_statements", ["buyer_id"], name: "index_fund_statements_on_buyer_id", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.string   "invoice_no"
    t.decimal  "face_value",                       default: 0.0
    t.string   "purchase_order_number"
    t.date     "date"
    t.date     "due_date"
    t.date     "anticipated_pay_date"
    t.date     "merchandise_shipped_on"
    t.date     "merchandise_arrived_on"
    t.string   "shipping_company_url"
    t.string   "tracking_code"
    t.date     "services_started_on"
    t.date     "services_ended_on"
    t.text     "services_description"
    t.string   "discounts_offered"
    t.string   "funding_status"
    t.boolean  "service_rendered",                 default: false
    t.boolean  "customer_satisfied",               default: false
    t.boolean  "payment_to_be_sent",               default: false
    t.integer  "seller_id"
    t.integer  "debtor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "admin_funding_status_notes"
    t.string   "payment_status",                   default: "Outstanding"
    t.string   "amount_paid_by_debtor"
    t.date     "paid_on"
    t.date     "funded_on"
    t.text     "admin_general_notes"
    t.datetime "payment_status_notification_sent"
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
    t.datetime "fully_paid_on_date"
    t.string   "rating_value"
    t.integer  "trade_id"
    t.string   "workflow_state",                   default: "pending"
    t.integer  "buyer_id"
  end

  create_table "mandates", force: :cascade do |t|
    t.decimal  "percentage_of_funds_for_investor"
    t.decimal  "percentage_of_each_invoice"
    t.integer  "debtor_id"
    t.integer  "buyer_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "mandates", ["buyer_id"], name: "index_mandates_on_buyer_id", using: :btree
  add_index "mandates", ["debtor_id"], name: "index_mandates_on_debtor_id", using: :btree

  create_table "master_ratings", force: :cascade do |t|
    t.string   "rating_value"
    t.decimal  "discount_rate",  null: false
    t.decimal  "advance_amount", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "payables", force: :cascade do |t|
    t.string   "invoice_no"
    t.decimal  "face_value",            default: 0.0
    t.string   "purchase_order_number"
    t.date     "date"
    t.date     "due_date"
    t.date     "anticipated_pay_date"
    t.integer  "seller_id"
    t.integer  "debtor_id"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_id"
  end

  add_index "payables", ["debtor_id"], name: "index_payables_on_debtor_id", using: :btree
  add_index "payables", ["seller_id"], name: "index_payables_on_seller_id", using: :btree

  create_table "preferences", force: :cascade do |t|
    t.decimal  "seller_exchange_fee", default: 0.008
    t.decimal  "buyer_exchange_fee",  default: 0.008
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profit_and_loss_attachments", force: :cascade do |t|
    t.string   "file_id"
    t.string   "file_name"
    t.integer  "seller_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: :cascade do |t|
    t.string   "master_rating_value",      null: false
    t.decimal  "discount_rate",            null: false
    t.decimal  "advance_amount",           null: false
    t.datetime "master_rating_applied_at", null: false
    t.integer  "invoice_id",               null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "scenario_invoices", force: :cascade do |t|
    t.integer "invoice_id"
    t.integer "cash_flow_scenario_id"
    t.boolean "is_sold"
    t.boolean "is_hidden"
    t.date    "due_date"
    t.date    "anticipated_pay_date"
  end

  add_index "scenario_invoices", ["cash_flow_scenario_id"], name: "index_scenario_invoices_on_cash_flow_scenario_id", using: :btree
  add_index "scenario_invoices", ["invoice_id"], name: "index_scenario_invoices_on_invoice_id", using: :btree

  create_table "scenario_payables", force: :cascade do |t|
    t.integer "payable_id"
    t.integer "cash_flow_scenario_id"
    t.boolean "is_hidden"
    t.date    "anticipated_pay_date"
  end

  add_index "scenario_payables", ["cash_flow_scenario_id"], name: "index_scenario_payables_on_cash_flow_scenario_id", using: :btree
  add_index "scenario_payables", ["payable_id"], name: "index_scenario_payables_on_payable_id", using: :btree

  create_table "seller_companies", force: :cascade do |t|
    t.string   "name"
    t.integer  "years_in_business"
    t.string   "address"
    t.string   "phone_number"
    t.string   "website"
    t.string   "acn"
    t.string   "abn"
    t.text     "description"
    t.string   "principal_business_owner"
    t.string   "principal_ownership"
    t.string   "other_registered_name"
    t.string   "avatar_id"
    t.string   "industry"
    t.datetime "approved"
    t.integer  "seller_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "associated_institutions"
    t.string   "legal_name"
    t.boolean  "pays_tax"
    t.string   "version"
    t.string   "base_currency"
    t.string   "registration_number"
    t.string   "tax_number"
    t.string   "financial_year_end_day"
    t.string   "financial_year_end_month"
    t.string   "organisation_type"
    t.string   "short_code"
    t.json     "addresses"
    t.json     "phones"
    t.string   "external_links"
    t.string   "directors_name"
    t.string   "directors_email"
    t.string   "directors_address"
  end

  create_table "sellers", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "workflow_state"
    t.datetime "error_importing_from_xero"
    t.string   "accounting_platform"
    t.datetime "dob"
    t.string   "drivers_license_number"
    t.boolean  "is_authorised_officer"
    t.decimal  "exchange_fee"
    t.boolean  "accepted_terms",            default: false
    t.boolean  "is_cash_flow_user",         default: false
  end

  create_table "trades", force: :cascade do |t|
    t.decimal  "total_face_value",                                  null: false
    t.decimal  "advance_amount",                                    null: false
    t.decimal  "net_advance_amount"
    t.decimal  "discount_fee",                                      null: false
    t.date     "funded_on"
    t.string   "funding_status",      default: "Invoices Unfunded"
    t.datetime "confirmed_at"
    t.decimal  "seller_exchange_fee"
    t.decimal  "buyer_exchange_fee"
    t.integer  "seller_id",                                         null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "name"
    t.string   "email",                          null: false
    t.string   "encrypted_password", limit: 128, null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128, null: false
    t.integer  "account_type"
    t.integer  "userable_id"
    t.string   "userable_type"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["userable_id"], name: "index_users_on_userable_id", using: :btree

  create_table "vendors", force: :cascade do |t|
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

  create_table "xero_authorisations", force: :cascade do |t|
    t.string   "request_token"
    t.string   "request_secret"
    t.string   "access_token"
    t.string   "access_key"
    t.string   "oauth_verifier"
    t.string   "host"
    t.datetime "access_token_updated_at"
    t.integer  "seller_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_foreign_key "buyer_companies", "buyers"
end
