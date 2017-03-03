require 'rails_helper'

describe Debtor do
  it 'has a valid factory' do
    expect(build(:debtor)).to be_valid
  end

  context 'associations' do
    it { should have_many(:attachments) }
    it { should have_many(:invoices).dependent(:destroy) }
    it { should belong_to(:seller) }
    it { should belong_to(:seller_company) }
  end

  context 'validations' do
    it { should validate_presence_of(:legal_business_name) }
  end

  context "delegations" do
    it { should delegate_method(:name).to(:seller).with_prefix(true) }
    it { should delegate_method(:name).to(:seller_company).with_prefix(true) }
  end
end

describe Debtor, 'custom validations' do
  it 'does not accept a relationship start date less than a year from today' do
    debtor = build(:debtor, relationship_start_date: Date.current)

    expect(debtor).not_to be_valid
    expect(debtor.errors.full_messages).to include "Relationship start date cannot be less than 1 year."
  end
end

describe Debtor do
  describe "#status" do
    it "has pending and approved statuses" do
      statuses = %w(pending approved)

      statuses.each do |status|
        expect(Debtor.statuses.keys).to include status
      end
    end
  end

  describe "#credit_reports" do
    it "returns a collection of credit report attachments" do
      debtor = create(:debtor)
      credit_report = create(:attachment, :credit_report, attachable: debtor)
      another_report = create(:attachment, :credit_report, attachable: debtor)

      credit_reports = debtor.credit_reports

      expect(credit_reports).to eq([another_report, credit_report])
    end
  end

  describe "#sales_agreements" do
    it "returns a collection of sales agreements" do
      debtor = create(:debtor)
      sales_agreement = create(:attachment,
                               :sales_agreement,
                               attachable: debtor)
      another_agreement = create(:attachment,
                                 :sales_agreement,
                                 attachable: debtor)

      sales_agreements = debtor.sales_agreements

      expect(sales_agreements).to eq([another_agreement, sales_agreement])
    end
  end

  describe "#customer_receipts" do
    it "returns a collection of sales agreements" do
      debtor = create(:debtor)
      receipt = create(:attachment, :customer_receipt, attachable: debtor)
      another_receipt = create(:attachment,
                               :customer_receipt,
                               attachable: debtor)

      customer_receipts = debtor.customer_receipts

      expect(customer_receipts).to eq([another_receipt, receipt])
    end
  end

  describe "#debtor_and_seller_company_name" do
    it "returns the debtors name with associated seller company name" do
      seller_company = create(:seller_company, name: "Fruit Shop")
      debtor = create(:debtor, legal_business_name: "Woolies", seller_company: seller_company)

      label = debtor.debtor_and_seller_company_name

      expect(label).to eq "Woolies (Fruit Shop)"
    end
  end
end
