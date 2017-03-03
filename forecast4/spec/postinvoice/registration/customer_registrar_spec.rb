require "rails_helper"

describe Registration::CustomerRegistrar do
  describe "#call" do
    it "registers customer information by creating debtors" do
      seller = create(:seller)

      Registration::CustomerRegistrar.new(
        registration_params.merge(seller_id: seller.id)
      ).call
      last_debtor = Debtor.last

      expect(Debtor.count).to eq 2
      expect(last_debtor.seller).to eq seller
      expect(last_debtor.legal_business_name).to eq "Coles"
      expect(last_debtor.acn).to eq "83838383"
      expect(last_debtor.value_of_outstanding_invoices).to eq "3883833"
      expect(last_debtor.seller_company).to eq seller.seller_company
      expect(seller.seller_company.invoice_documents.count).to eq 1
    end

    it "doesn't create any debtors if params are blank" do
      seller = create(:seller)

      Registration::CustomerRegistrar.new(
        blank_registration_params.merge(seller_id: seller.id)
      ).call

      expect(Debtor.count).to eq 0
    end
  end

  def registration_params
      {
        "debtors" =>
          [
            {
              "legal_business_name"=>"Woolies",
              "acn"=>"123455",
              "value_of_outstanding_invoices"=>"838383"
            },
            {
              "legal_business_name"=>"Coles",
              "acn"=>"83838383",
              "value_of_outstanding_invoices"=>"3883833"
            }
          ],
        "invoice_documents" => [
          "image/upload/v1446766428/financial_statements/test-file.pdf#36291161a3e0c489a8876be5de9dfe6cb96095b2"
        ]
      }
  end

  def blank_registration_params
      {
        "debtors" =>
          [
            {
              "legal_business_name"=>"",
              "acn"=>"",
              "value_of_outstanding_invoices"=>""
            },
          ],
      }
  end
end
