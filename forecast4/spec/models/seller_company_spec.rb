require 'rails_helper'

describe SellerCompany do
  it 'has a valid factory' do
    expect(build(:seller_company)).to be_valid
  end

  context 'associations' do
    it { should belong_to(:seller) }
    it { should have_one(:bank_details) }
    it { should have_one(:financials) }
    it { should have_one(:debtor_terms) }
    it { should have_many(:attachments) }
    it { should have_many(:existing_facilities) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    # it { should validate_uniqueness_of(:short_code) }
  end

  describe ".ordered" do
    it "returns the latest 10 records" do
      first_seller_company = create(:seller_company)
      10.times { create(:seller_company) }
      last_seller_company = create(:seller_company)

      ordered_seller_companies = SellerCompany.ordered

      expect(ordered_seller_companies.length).to eq 10
      expect(ordered_seller_companies.first).to eq last_seller_company
      expect(ordered_seller_companies).not_to include first_seller_company
    end
  end

  describe "#financial_statements" do
    it "returns the newest financial statements first" do
      seller_company = create(:seller_company)
      oldest = create(:attachment, :financial_statements, attachable: seller_company)
      newest = create(:attachment, :financial_statements, attachable: seller_company)

      financial_statements = seller_company.financial_statements

      expect(financial_statements).to eq([newest, oldest])
    end
  end

  describe "#bank_statements" do
    it "returns the newest bank statements first" do
      seller_company = create(:seller_company)
      oldest = create(:attachment, :bank_statements, attachable: seller_company)
      newest = create(:attachment, :bank_statements, attachable: seller_company)

      bank_statements = seller_company.bank_statements

      expect(bank_statements).to eq([newest, oldest])
    end
  end

  describe "#invoice_documents" do
    it "returns the newest aged payable reports first" do
      seller_company = create(:seller_company)
      oldest = create(:attachment, :invoice_document, attachable: seller_company)
      newest = create(:attachment, :invoice_document, attachable: seller_company)

      invoice_documents = seller_company.invoice_documents

      expect(invoice_documents).to eq([newest, oldest])
    end
  end

  describe "#misc_documents" do
    it "returns the newest misc documents first" do
      seller_company = create(:seller_company)
      oldest = create(:attachment, attachable: seller_company)
      newest = create(:attachment, attachable: seller_company)

      misc_documents = seller_company.misc_documents

      expect(misc_documents).to eq([newest, oldest])
    end
  end
end
