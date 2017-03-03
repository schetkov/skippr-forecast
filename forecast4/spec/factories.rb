FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  # create(:user, :seller, name: "Ralph Wintle")
  # create(:user, :seller, :with_company, name: "Ralph Wintle"
  factory :user do
    name "John Smith"
    email
    password "Password1234"
    account_type "seller"

    trait :admin do
      account_type "admin"
    end

    trait :seller do
      account_type 1
      after(:create) do |user|
        user.update(userable: create(:seller))
      end
    end

    trait :buyer do
      account_type 0
      after(:create) do |user|
        user.update(userable: create(:buyer))
      end
    end
  end

  # create(:seller, :completed)
  factory :seller do
    workflow_state "completed"
    exchange_fee 0.01

    after(:create) { |seller| create(:seller_company, seller: seller) }
    after(:create) { |seller| create(:user, account_type: 1, userable: seller) }
  end

  # create(:buyer, :completed)
  factory :buyer do
    workflow_state "approved"

    after(:create) { |buyer| create(:buyer_company, buyer: buyer) }
    after(:create) { |buyer| create(:user, account_type: 0, userable: buyer) }

    trait :incomplete do
      status "incomplete"
    end

    trait :awaiting_approval do
      status "awaiting_approval"
    end

    trait :completed do
      status "complete"
    end

    trait :sophisticated do
      investor_type "sophisticated"
    end

    trait :high_net_worth do
      investor_type "high_net_worth"
    end

    trait :institution do
      investor_type "institution"
    end
  end

  # create(:company)
  factory :seller_company do
    seller

    name "My Company Ltd"
    years_in_business 1
    address "My Company Address"
    phone_number "9876 5432"
    website "http://www.company-website.com"
    acn "12345"
    description "This is my company description"
    principal_business_owner "Peter Smith"
    principal_ownership "100"

    sequence :short_code do |n|
      "abc#{n}!"
    end

    trait :with_bank_details do
      after(:create) { |company| create(:bank_details, bankable: company) }
    end
  end

  factory :buyer_company do
    buyer

    name "My Company Ltd"
  end

  factory :attachment do
    file_id "v1/folder/file_name"
    file_name "folder/file_name"
    file_type "misc"

    trait :balance_sheet do
      file_type "balance_sheet"
      attachable_type "Seller"
    end

    trait :profit_and_loss do
      file_type "profit_and_loss"
      attachable_type "Seller"
    end

    trait :financial_statements do
      file_type "financial_statements"
      attachable_type "Seller"
    end

    trait :bank_statements do
      file_type "bank_statements"
      attachable_type "Seller"
    end

    trait :aged_payable_report do
      file_type "aged_payable_report"
      attachable_type "Seller"
    end

    trait :ageing_debtor_report do
      file_type "ageing_debtor_report"
      attachable_type "Seller"
    end

    trait :drivers_license do
      file_type "drivers_license"
      attachable_type "Seller"
    end

    trait :credit_report do
      file_type "credit_report"
      attachable_type "Seller"
    end

    trait :sales_agreement do
      file_type "sales_agreement"
      attachable_type "Debtor"
    end

    trait :customer_receipt do
      file_type "customer_receipt"
      attachable_type "Debtor"
    end

    trait :invoice_document do
      file_type "invoice_document"
      attachable_type "Invoice"
    end

    trait :purchase_order do
      file_type "purchase_order"
      attachable_type "Invoice"
    end

    trait :ppsr do
      file_type "ppsr"
      attachable_type "Invoice"
    end

    trait :notice_of_assignment do
      file_type "notice_of_assignment"
      attachable_type "Invoice"
    end

    trait :afsl do
      file_type "afsl"
      attachable_type "Buyer"
    end

    trait :letter_from_accountant do
      file_type "letter_from_accountant"
      attachable_type "Buyer"
    end
  end

  factory :afsl do
    number "12345"
  end

  # create(:debtor, :approved)
  factory :debtor do
    seller

    legal_business_name "Debtor Ltd"
    address "101 Address"
    acn "12345"
    business_type "Private"
    business_sector "Construction"
    contact_name "Mary Smith"
    contact_phone_number "02 1234 6789"
    contact_email "mary@example.com"
    internal_account_debtor_id "321"
    customer_reference_id "123"
    other_name ""
    thirty_days 1000
    sixty_days 1000
    ninety_days 1000
    over_ninety_days 1000
    warranties "no"
    progressive_billing "no"
    return_rights "no"
    consignment_basis "no"
    credit_terms "no"
    relationship_start_date 2.years.ago
    status "pending"

    trait :approved do
      status "approved"
    end
  end

  # create(:invoice, :approved)
  factory :invoice do
    sequence :invoice_no do |n|
      "#{n}"
    end

    sequence :invoice_xero_id do |n|
      "#{n}"
    end

    debtor
    seller
    buyer
    face_value 10000
    purchase_order_number "321"
    date (Time.zone.now - 1.week).to_date
    due_date (Time.zone.now + 1.week).to_date
    anticipated_pay_date (Time.zone.now + 3.days).to_date
    services_description "Description goes here."
    # discounts_offered ""
    workflow_state "pending"

    trait :approved do
      workflow_state "approved"
      after(:create) { |i| create(:rating, invoice: i) }
    end

    trait :selected do
      workflow_state "selected"
      after(:create) { |i| create(:rating, invoice: i) }
    end

    trait :sold do
      workflow_state "sold"
      after(:create) { |i| create(:rating, invoice: i) }
    end

    trait :funded do
      workflow_state "funded"
      after(:create) { |i| create(:rating, invoice: i) }
    end

    trait :repaid do
      workflow_state "repaid"
      after(:create) { |i| create(:rating, invoice: i) }
    end

    trait :active do
      due_date (Time.zone.now + 1.day).to_date
      after(:create) { |i| create(:rating, invoice: i) }
    end

    trait :expired do
      due_date (Time.zone.now - 1.day).to_date
    end

    trait :with_purchase_order_file do
      after(:create) { |i| create(:attachment, :purchase_order, attachable: i) }
    end
  end

  factory :mandate do
    debtor
    buyer
  end

  # create(:financial)
  factory :financials do
    seller_company

    net_revenues 1000
    gross_profit_margin 1000
    last_reported_trade_debtors 1000
    last_reported_trade_creditors 1000
    loans_outstanding 1000
    liability_outstanding 1000
  end

  # create(:debtor_terms)
  factory :debtor_terms do
    seller_company

    warranties "no"
    progressive_billing "no"
    return_rights "no"
    consignment_basis "no"
    discounts "no"
  end

  factory :accountant do
    buyer_company
  end

  factory :bank_details do
    account_name "John Smith"
    account_number "12345"
    bsb_number "12345"
  end

  factory :preference do
    buyer_exchange_fee 0.008
    seller_exchange_fee 0.008
  end

  factory :fees do
  end

  factory :xero_authorisation do
    access_token_updated_at DateTime.now - 10.minutes
  end

  factory :master_rating do
    rating_value "1"
    discount_rate 0.05
    advance_amount 0.85
  end

  factory :rating do
    invoice
    master_rating_value "1"
    discount_rate 0.10
    advance_amount 0.85
    master_rating_applied_at Date.current
  end

  factory :trade do
    seller
    total_face_value 10000.0
    advance_amount 9000.0
    discount_fee 1000.0

    trait :confirmed do
      confirmed_at Date.current
    end
  end

  factory :fund_statement do
    buyer
  end

  factory :cash_flow_rule do
    amount 10.0
  end

  factory :payable do
    face_value 10_000
    date Date.current - 10.days
    due_date Date.current + 30.days
  end
end
