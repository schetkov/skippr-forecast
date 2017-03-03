require "rails_helper"

describe Attachments::AttachmentCreator do
  describe "#call" do
    context "with a persisted resource" do
      it "creates a single attachment for given resource" do
        seller = create(:seller)
        file_attributes = [
          {
            file_id: "123",
            file_name: "file_name",
            file_type: "profit_and_loss"
          }
        ]

        Attachments::AttachmentCreator.new(
          file_attributes: file_attributes,
          resource: seller
        ).call

        expect(seller.attachments.count).to eq 1
        expect(seller.attachments.first.file_type).to eq "profit_and_loss"
      end

      it "creates multiple attachments for a given resource" do
        seller = create(:seller)
        file_attributes = [
          {
            file_id: "123",
            file_name: "file_name",
            file_type: "profit_and_loss"
          },
          {
            file_id: "321",
            file_name: "file_name",
            file_type: "balance_sheet"
          }
        ]

        Attachments::AttachmentCreator.new(
          file_attributes: file_attributes,
          resource: seller
        ).call

        expect(seller.attachments.count).to eq 2
        expect(seller.attachments.first.file_type).to eq "profit_and_loss"
        expect(seller.attachments.last.file_type).to eq "balance_sheet"
      end
    end

    context "with a not yet persisted resource" do
      it "creates a single attachment for given resource" do
        seller = build(:seller)
        file_attributes = [
          {
            file_id: "123",
            file_name: "file_name",
            file_type: "profit_and_loss"
          }
        ]

        Attachments::AttachmentCreator.new(
          file_attributes: file_attributes,
          resource: seller
        ).call

        expect(seller.attachments.first.file_type).to eq "profit_and_loss"
        expect(seller.attachments.count).to eq 0
      end
    end
  end
end
