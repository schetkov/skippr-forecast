require "rails_helper"

RSpec.describe Attachment, type: :model do
  it "has a valid factory" do
    expect(build(:attachment)).to be_valid
  end

  context "associations" do
    it { should belong_to(:attachable) }
  end

  context "validations" do
    it { should validate_presence_of(:file_id) }
    it { should validate_presence_of(:file_name) }
    it { should validate_presence_of(:file_type) }
  end

  describe "enums" do
    it "includes all attachment types" do
      file_types = [
        "misc",
        "balance_sheet",
        "profit_and_loss",
        "aged_payable_report",
        "ageing_debtor_report",
        "drivers_license",
        "credit_report",
        "sales_agreement",
        "customer_receipt",
        "invoice_document",
        "purchase_order",
        "ppsr",
        "notice_of_assignment",
        "letter_from_accountant",
        "afsl",
        "financial_statements",
        "bank_statements"
      ]

      file_types.each do |file_type|
        expect(Attachment.file_types.keys).to include file_type
      end
    end
  end

  describe ".ordered" do
    it "returns attachments in descending order" do
      oldest_attachment = create(:attachment)
      newest_attachment = create(:attachment)

      attachments = Attachment.ordered

      expect(attachments).to eq [newest_attachment, oldest_attachment]
    end
  end
end
