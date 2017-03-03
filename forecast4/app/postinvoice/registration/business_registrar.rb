module Registration
  class BusinessRegistrar
    include ActiveModel::Model

    validates :financial_statements, presence: true,
              if: :should_validate_financial_statements?

    attr_accessor(
      :seller_id,
      :accounting_platform,
      :existing_facility,
      :financial_statements,
      :bank_statements,
      :other_supporting_documents
    )

    def call
      if self.valid?
        seller.update(accounting_platform: accounting_platform)
        existing_facility.each do |facility|
          create_seller_company_facility(seller, facility)
        end
        create_attachments
        self
      else
        self
      end
    end

    private

    def seller
      @seller ||= Seller.find(seller_id)
    end

    def create_seller_company_facility(seller, facility)
      ExistingFacility.new.tap do |f|
        f.name = facility["name"]
        f.amount = facility["amount"]
        f.secured = facility["secured"]
        f.seller_company_id = seller.seller_company.id
        f.save
      end
    end

    def create_attachments
      if attachments
        attachments.each do |attachment_params|
          Attachments::AttachmentCreator.new(
            file_attributes: cloudinary_attribute_builder(attachment_params),
            resource: seller.seller_company
          ).call
        end
      end
    end

    def cloudinary_attribute_builder(attachment_param)
      Attachments::CloudinaryAttributeBuilder.new(attachment_param).call
    end

    def attachments
      financial_statement_attachments +
        bank_statement_attachments +
        other_attachments
    end

    def financial_statement_attachments
      if financial_statements
        financial_statements.inject([]) do |result, memo|
          result << { "financial_statements" => memo }
        end
      else
        []
      end
    end

    def bank_statement_attachments
      if bank_statements
        bank_statements.inject([]) do |result, memo|
          result << { "bank_statements" => memo }
        end
      else
        []
      end
    end

    def other_attachments
      if other_supporting_documents
        other_supporting_documents.inject([]) do |result, memo|
          result << { "misc" => memo }
        end
      else
        []
      end
    end

    def should_validate_financial_statements?
      seller.seller_company.financial_statements.empty?
    end
  end
end
