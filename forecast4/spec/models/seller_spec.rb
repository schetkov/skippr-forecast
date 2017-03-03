require 'rails_helper'

describe Seller do
  it 'has a valid factory' do
    expect(build(:seller)).to be_valid
  end

  context 'associations' do
    it { should have_one(:user) }
    it { should have_one(:seller_company) }
    it { should have_many(:invoices) }
    it { should have_many(:debtors) }
    it { should have_many(:attachments) }
    it { should have_many(:xero_authorisations) }
    it { should have_many(:trades) }
    it { should accept_nested_attributes_for(:user) }
    it { should accept_nested_attributes_for(:seller_company) }
  end

  context "delegations" do
    it { should delegate_method(:name).to(:user) }
    it { should delegate_method(:email).to(:user) }
    it { should delegate_method(:name).to(:seller_company).with_prefix(true) }
    it { should delegate_method(:website).to(:seller_company).with_prefix(true) }
    it { should delegate_method(:phone_number).to(:seller_company).with_prefix(true) }
    it { should delegate_method(:acn).to(:seller_company).with_prefix(true) }
  end

  context "validations" do
    it { should validate_presence_of(:exchange_fee) }
  end
end

describe Seller do
  describe "state" do
    it "includes all registration steps" do
      registration_states = [
        :new,
        :business_registration,
        :customer_registration,
        :terms_registration,
        :completed
      ]

      registration_states.each do |state|
        expect(Seller.workflow_spec.state_names).to include state
      end
    end
  end

  describe ".ordered" do
    it "returns the latest 10 records" do
      first_seller = create(:seller)
      10.times { create(:seller) }
      last_seller = create(:seller)

      ordered_sellers = Seller.ordered

      expect(ordered_sellers.length).to eq 10
      expect(ordered_sellers.first).to eq last_seller
      expect(ordered_sellers).not_to include first_seller
    end
  end

  describe "#latest_misc_documents" do
    it "returns the newest aged payable reports first" do
      seller = create(:seller)
      oldest = create(:attachment, attachable: seller.seller_company)
      middle = create(:attachment, attachable: seller.seller_company)
      newest = create(:attachment, attachable: seller.seller_company)

      latest_misc_documents = seller.latest_misc_documents

      expect(latest_misc_documents).to eq([newest, middle, oldest])
    end
  end

  describe "#latest_financial_statements" do
    it "returns the newest financial statements first" do
      seller = create(:seller)
      oldest = create(:attachment, :financial_statements, attachable: seller.seller_company)
      middle = create(:attachment, :financial_statements, attachable: seller.seller_company)
      newest = create(:attachment, :financial_statements, attachable: seller.seller_company)

      latest_financial_statements = seller.latest_financial_statements

      expect(latest_financial_statements).to eq([newest, middle, oldest])
    end
  end

  describe "#latest_bank_statements" do
    it "returns the newest bank statements first" do
      seller = create(:seller)
      oldest = create(:attachment, :bank_statements, attachable: seller.seller_company)
      middle = create(:attachment, :bank_statements, attachable: seller.seller_company)
      newest = create(:attachment, :bank_statements, attachable: seller.seller_company)

      latest_bank_statements = seller.latest_bank_statements

      expect(latest_bank_statements).to eq([newest, middle, oldest])
    end
  end

  describe "#latest_invoices" do
    it "returns the newest invoices first" do
      seller = create(:seller)
      create(:debtor, seller: seller)
      oldest_invoice = create(:invoice, seller: seller)
      middle_invoice = create(:invoice, seller: seller)
      newest_invoice = create(:invoice, seller: seller)

      invoices = seller.latest_invoices

      expect(invoices).to eq([newest_invoice, middle_invoice, oldest_invoice])
    end
  end

  describe "#drivers_license" do
    it "returns the last uploaded drivers license" do
      seller = create(:seller)
      drivers_license = create(:attachment,
                               :drivers_license,
                               attachable: seller)

      expect(seller.drivers_license).to eq drivers_license
    end
  end

  describe "#credit_reports" do
    it "returns a collection of credit report attachments" do
      seller = create(:seller)
      credit_report = create(:attachment, :credit_report, attachable: seller)
      another_report = create(:attachment, :credit_report, attachable: seller)

      credit_reports = seller.credit_reports

      expect(credit_reports).to eq([another_report, credit_report])
    end
  end

  describe "#has_xero_access_token?" do
    it "is true if the seller has an existing access token from xero" do
      xero_seller = create(:seller)
      other_seller = create(:seller)
      create(:xero_authorisation, access_token: "12345", seller: xero_seller)

      expect(xero_seller.has_xero_authorisation?).to eq true
      expect(other_seller.has_xero_authorisation?).to eq false
    end
  end
end

describe Seller, "#welcome_notification" do
  it "sends welcome email to seller" do
    seller = build(:seller)
    mailer = double("mailer", deliver_now: true)
    allow(Mailer).to receive(:seller_welcome_notification).
      with(seller).and_return(mailer)

    seller.welcome_notification!

    expect(Mailer).to have_received(:seller_welcome_notification).with(seller)
    expect(mailer).to have_received(:deliver_now).once
  end
end

describe Seller, "#approval_notification" do
  it "sends email notifying of approval to seller" do
    seller = build(:seller)
    mailer = double("mailer", deliver_now: true)
    allow(Mailer).to receive(:seller_approval_notification).
      with(seller).and_return(mailer)

    seller.approval_notification!

    expect(Mailer).to have_received(:seller_approval_notification).with(seller)
    expect(mailer).to have_received(:deliver_now).once
  end
end

describe Seller, '#payment_status_notification' do
  it "sends an email when admin has updated the payment status" do
    seller = create(:seller)
    invoice = create(:invoice, seller: seller)
    mailer = double('mailer', deliver_now: true)
    allow(Mailer).to receive(:seller_payment_status_notification).
      with(seller, invoice).and_return(mailer)

    seller.payment_status_notification!(invoice)

    expect(Mailer).to have_received(:seller_payment_status_notification).
      with(seller, invoice)
    expect(mailer).to have_received(:deliver_now).once
  end
end

describe Seller, "#total_value_of_invoices_funded" do
  it "calculates the sum of all funded trades" do
    seller = create(:seller)
    create(:trade, :confirmed, total_face_value: 10_000, seller: seller)
    create(:trade, :confirmed, total_face_value: 10_000, seller: seller)
    create(:trade, :confirmed, total_face_value: 10_000, seller: seller)

    total_value = seller.total_value_of_invoices_funded

    expect(total_value).to eq 30_000
  end
end

describe Seller, "#total_value_of_funding_available" do
  it "calculates sum of all approved invoices to show funding available" do
    seller = create(:seller)
    create(:invoice, :approved, face_value: 10_000, seller: seller)
    create(:invoice, :approved, face_value: 10_000, seller: seller)
    create(:invoice, face_value: 10_000, seller: seller)

    total_value = seller.total_value_of_funding_available

    expect(total_value).to eq 20_000
  end

  it "does not take into account approved invoices that belong to confirmed trades" do
    seller = create(:seller)
    trade = create(:trade, :confirmed)
    create(:invoice,
           :approved,
           face_value: 10_000,
           seller: seller,
           trade: trade)
    create(:invoice,
           :approved,
           face_value: 10_000,
           seller: seller)

    total_value = seller.total_value_of_funding_available

    expect(total_value).to eq 10_000
  end
end

describe Seller, "#total_value_of_potential_funding_available" do
  it "calculates the sum of all pending invoices to show potential funding" do
    seller = create(:seller)
    create(:invoice,
           face_value: 10_000,
           workflow_state: "pending",
           seller: seller)
    create(:invoice,
           face_value: 10_000,
           workflow_state: "selected",
           seller: seller)
    create(:invoice, :approved, face_value: 10_000, seller: seller)

    total_value = seller.total_value_of_potential_funding_available

    expect(total_value).to eq 20_000
  end
end

describe Seller, "#uses_xero?" do
  it "returns true if seller's accounting platform is Xero" do
    seller = create(:seller, accounting_platform: "Xero")

    expect(seller.xero_user?).to eq true
  end

  it "returns false if seller's accounting platform is not Xero" do
    seller = create(:seller, accounting_platform: "myob")

    expect(seller.xero_user?).to eq false
  end
end

describe Seller, "#has_an_approved_invoice?" do
  it "returns true if the seller has one approved invoice ready for trade" do
    seller = create(:seller)
    create(:invoice, :approved, :active, seller: seller)

    expect(seller.has_an_approved_invoice?).to eq true
  end

  it "returns false if seller has no approved invoices ready for trade" do
    seller = create(:seller)

    expect(seller.has_an_approved_invoice?).to eq false
  end
end

describe "#register_customer!" do
  it "registers the customer if they are in business_registration state" do
    seller = create(:seller, workflow_state: "customer_registration")

    seller.register_customer!

    expect(seller.reload.workflow_state).to eq "terms_registration"
  end

  it "doesn't call event update if not in business_registration state" do
    seller = create(:seller, workflow_state: "completed")

    seller.register_customer!

    expect(seller.reload.workflow_state).to eq "completed"
  end
end
