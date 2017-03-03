module Registration
  class CustomerRegistrar
    include ActiveModel::Model
    attr_accessor(
      :debtors,
      :seller_id,
      :invoice_documents
    )

    def call
      filtered_debtor_attributes.each do |debtor|
        seller.debtors.build do |d|
          d.value_of_outstanding_invoices = debtor["value_of_outstanding_invoices"]
          d.legal_business_name = debtor["legal_business_name"]
          d.acn = debtor["acn"]
          d.seller_company = seller.seller_company
          d.save
        end
      end

      create_attachments
    end

    private

    def seller
      @seller ||= Seller.find(seller_id)
    end

    def filtered_debtor_attributes
      debtors.delete_if do |debtor|
        debtor.values.map(&:blank?).include? true
      end
    end

    def create_attachments
      if invoice_documents
        invoice_documents.each do |attachment_params|
          Attachments::AttachmentCreator.new(
            file_attributes: cloudinary_attribute_builder(attachment_params),
            resource: seller.seller_company
          ).call
        end
      end
    end

    def cloudinary_attribute_builder(attachment_param)
      Attachments::CloudinaryAttributeBuilder.new(
        "invoice_document" => attachment_param
      ).call
    end
  end
end
