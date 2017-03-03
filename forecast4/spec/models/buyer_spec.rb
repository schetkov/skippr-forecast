require 'rails_helper'

describe Buyer do
  it 'has a valid factory' do
    expect(build(:buyer)).to be_valid
  end

  context 'associations' do
    it { should have_one(:user) }
    it { should have_many(:attachments) }
    it { should have_many(:mandates) }
    it { should have_many(:fund_statements) }
    it { should have_many(:invoices) }
    it { should have_many(:debtors).through(:invoices) }
  end

  context "delegations" do
    it { should delegate_method(:name).to(:user) }
    it { should delegate_method(:email).to(:user) }
    it { should delegate_method(:name).to(:buyer_company).with_prefix(true) }
  end
end

describe Buyer do
  describe "state" do
    it "includes all registration steps" do
      registration_states = [
        :new,
        :confirmed,
        :completed,
        :approved
      ]

      registration_states.each do |state|
        expect(Buyer.workflow_spec.state_names).to include state
      end
    end
  end

  describe ".ordered" do
    it "returns the latest 10 records" do
      first_buyer = create(:buyer)
      10.times { create(:buyer) }
      last_buyer = create(:buyer)

      ordered_buyers = Buyer.ordered

      expect(ordered_buyers.length).to eq 10
      expect(ordered_buyers.first).to eq last_buyer
      expect(ordered_buyers).not_to include first_buyer
    end
  end

  describe "#afsl" do
    it "returns last afsl attachment" do
      buyer = create(:buyer)
      create(:attachment, :afsl, attachable: buyer)

      afsl = buyer.afsl

      expect(afsl.file_type).to eq "afsl"
      expect(afsl.attachable_id).to eq buyer.id
    end
  end

  describe "#letter_from_accountant" do
    it "returns last afsl attachment" do
      buyer = create(:buyer)
      create(:attachment, :letter_from_accountant, attachable: buyer)

      letter_from_accountant = buyer.letter_from_accountant

      expect(letter_from_accountant.file_type).to eq "letter_from_accountant"
      expect(letter_from_accountant.attachable_id).to eq buyer.id
    end
  end

  describe "#incomplete?" do
    it "is true if buyer's state is new, confirmed or awaiting approval" do
      new_buyer = create(:buyer, workflow_state: "new")
      confirmed_buyer = create(:buyer, workflow_state: "confirmed")
      awaiting_buyer = create(:buyer, workflow_state: "awaiting approval")

      expect(new_buyer.incomplete?).to eq true
      expect(confirmed_buyer.incomplete?).to eq true
      expect(awaiting_buyer.incomplete?).to eq true
    end

    it "is false if buyer's state is completed or approved" do
      completed_buyer = create(:buyer, workflow_state: "completed")
      approved_buyer = create(:buyer, workflow_state: "approved")

      expect(completed_buyer.incomplete?).to eq false
      expect(approved_buyer.incomplete?).to eq false
    end
  end
end

describe Buyer, '#welcome_notification' do
  it "sends off welcome email to buyer" do
    buyer = build(:buyer)
    mailer = double('mailer', deliver_now: true)
    allow(Mailer).to receive(:buyer_welcome_notification).with(buyer).and_return(mailer)

    buyer.welcome_notification!

    expect(Mailer).to have_received(:buyer_welcome_notification).with(buyer)
    expect(mailer).to have_received(:deliver_now).once
  end
end

describe Buyer, '#approval_notification' do
  it "sends email notifying of approval to buyer" do
    buyer = build(:buyer)
    mailer = double('mailer', deliver_now: true)
    allow(Mailer).to receive(:buyer_approval_notification).
      with(buyer).and_return(mailer)

    buyer.approval_notification!

    expect(Mailer).to have_received(:buyer_approval_notification).with(buyer)
    expect(mailer).to have_received(:deliver_now).once
  end
end

describe Buyer, '#payment_status_notification' do
  it "sends an email when admin has updated the payment status" do
    buyer = create(:buyer)
    invoice = create(:invoice)
    mailer = double('mailer', deliver_now: true)
    allow(Mailer).to receive(:buyer_payment_status_notification).
      with(buyer, invoice).and_return(mailer)

    buyer.payment_status_notification!(invoice)

    expect(Mailer).to have_received(:buyer_payment_status_notification).
      with(buyer, invoice)
    expect(mailer).to have_received(:deliver_now).once
  end
end

describe Buyer, "#latest_fund_statement" do
  it "returns the latest fund statement" do
    buyer = create(:buyer)
    old_statement = create(:fund_statement, buyer: buyer)
    latest_statement = create(:fund_statement, buyer: buyer)

    expect(buyer.latest_fund_statement).to eq latest_statement
    expect(buyer.latest_fund_statement).not_to eq old_statement
  end
end

describe Buyer, "#find_relevant_mandate" do
  it "returns the mandate relevant to invoice based on debtor" do
    buyer = create(:buyer)
    debtor = create(:debtor)
    invoice = create(:invoice, debtor: debtor)
    correct_mandate = create(:mandate, buyer: buyer, debtor: debtor)
    incorrect_mandate = create(:mandate, buyer: buyer)

    mandate = buyer.find_relevant_mandate(invoice)

    expect(mandate).to eq correct_mandate
    expect(mandate).not_to eq incorrect_mandate
  end
end

describe Buyer, "#approved_invoices" do
  it "returns a collection of invoices with approved state" do
    buyer = create(:buyer)
    approved_invoice = create(:invoice, :approved, buyer: buyer)

    approved_invoices = buyer.approved_invoices

    expect(approved_invoices).to include approved_invoice
  end
end

describe Buyer, "#sold_invoices" do
  it "returns a collection of invoices with sold state" do
    buyer = create(:buyer)
    sold_invoice = create(:invoice, :sold, buyer: buyer)
    approved_invoice = create(:invoice, :approved, buyer: buyer)

    sold_invoices = buyer.sold_invoices

    expect(sold_invoices).to include sold_invoice
    expect(sold_invoices).not_to include approved_invoice
  end
end

describe Buyer, "#funded_invoices" do
  it "returns a collection of invoices with funded state" do
    buyer = create(:buyer)
    funded_invoice = create(:invoice, :funded, buyer: buyer)
    approved_invoice = create(:invoice, :approved, buyer: buyer)

    funded_invoices = buyer.funded_invoices

    expect(funded_invoices).to include funded_invoice
    expect(funded_invoices).not_to include approved_invoice
  end
end

describe Buyer, "#repaid_invoices" do
  it "returns a collection of invoices with funded state" do
    buyer = create(:buyer)
    repaid_invoice = create(:invoice, :repaid, buyer: buyer)
    approved_invoice = create(:invoice, :approved, buyer: buyer)

    repaid_invoices = buyer.repaid_invoices

    expect(repaid_invoices).to include repaid_invoice
    expect(repaid_invoices).not_to include approved_invoice
  end
end
