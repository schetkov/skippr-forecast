require "rails_helper"

describe Attachments::CloudinaryAttributeBuilder do
  describe "#call" do
    it "builds the correct params for a single attachment" do
      parameters = { "profit_and_loss" => "123", "some_other_param" => "321" }
      upload = double("Cloudinary::PreloadedFile",
                      valid?: true,
                      identifier: "123",
                      public_id: "file_name")
      allow(Cloudinary::PreloadedFile).to receive(:new).
        with("123").and_return(upload)

      attachment_params =
        Attachments::CloudinaryAttributeBuilder.new(parameters).call

      expect(attachment_params).to eq(
        [{
          file_id: "123",
          file_name: "file_name",
          file_type: "profit_and_loss"
        }])
    end

    it "builds the correct params for creating two attachments" do
      parameters = { "profit_and_loss" => "123", "balance_sheet" => "321" }
      first_upload = double("Cloudinary::PreloadedFile",
                            valid?: true,
                            identifier: "123",
                            public_id: "name")
      second_upload = double("Cloudinary::PreloadedFile",
                             valid?: true,
                             identifier: "321",
                             public_id: "name")
      allow(Cloudinary::PreloadedFile).to receive(:new).
        with("123") .and_return(first_upload)
      allow(Cloudinary::PreloadedFile).to receive(:new).
        with("321").and_return(second_upload)

      attachment_params =
        Attachments::CloudinaryAttributeBuilder.new(parameters).call

      expect(attachment_params).to eq([
        { file_id: "123", file_name: "name", file_type: "profit_and_loss" },
        { file_id: "321", file_name: "name", file_type: "balance_sheet" }])
    end

    it "ignores file params with nil values" do
      parameters = { "profit_and_loss" => "123", "balance_sheet" => nil }
      upload = double("Cloudinary::PreloadedFile",
                      valid?: true,
                      identifier: "123",
                      public_id: "name")
      allow(Cloudinary::PreloadedFile).to receive(:new).
        with("123").and_return(upload)
      attachment_params =
        Attachments::CloudinaryAttributeBuilder.new(parameters).call

      expect(attachment_params).to eq(
        [{
          file_id: "123",
          file_name: "name",
          file_type: "profit_and_loss"
        }])
    end
  end
end
