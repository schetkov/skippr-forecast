require "rails_helper"

describe Registration::BusinessRegistrar do
  context "validations" do
    before(:each) do
      seller = create(:seller)
      allow_any_instance_of(Registration::BusinessRegistrar).
        to receive(:seller_id).and_return(seller.id)
    end

    it { should validate_presence_of(:financial_statements) }
  end

  it "updates relevant records with registration information" do
    seller = create(:seller)
    registration_params = business_params.merge(seller_id: seller.id.to_s)

    Registration::BusinessRegistrar.new(registration_params).call
    seller.reload

    expect(seller.accounting_platform).to eq "xero"
    expect(seller.seller_company.existing_facilities.first.name).to eq "ANZ"
    expect(seller.seller_company.financial_statements.count).to eq 1
    expect(seller.seller_company.bank_statements.count).to eq 1
    expect(seller.seller_company.misc_documents.count).to eq 1
  end

  it "uploads multiple attachments" do
    seller = create(:seller)
    registration_params =
      business_params_with_multiple_attachments.merge(seller_id: seller.id.to_s)

    Registration::BusinessRegistrar.new(registration_params).call

    expect(seller.seller_company.attachments.count).to eq 4
  end

  def business_params
    {
      "accounting_platform"=>"xero",
      "existing_facility"=>
        [{
          "name"=>"ANZ",
          "amount"=>"100000",
          "secured"=>"Secured"
        }],
      "financial_statements"=>
        ["image/upload/v1446766428/financial_statements/test-file.pdf#36291161a3e0c489a8876be5de9dfe6cb96095b2"],
      "bank_statements"=>
        ["image/upload/v1446766428/financial_statements/test-file.pdf#36291161a3e0c489a8876be5de9dfe6cb96095b2"],
      "other_supporting_documents"=>
        ["image/upload/v1446766428/financial_statements/test-file.pdf#36291161a3e0c489a8876be5de9dfe6cb96095b2"],
    }
  end

  def business_params_with_multiple_attachments
    business_params.merge({
      "financial_statements" => [
        "image/upload/v1446766428/financial_statements/test-file.pdf#36291161a3e0c489a8876be5de9dfe6cb96095b2",
        "image/upload/v1446766428/financial_statements/test-file.pdf#36291161a3e0c489a8876be5de9dfe6cb96095b2"
      ]
    })
  end
end
