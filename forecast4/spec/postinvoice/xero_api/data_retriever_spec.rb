require "rails_helper"

describe XeroApi::DataRetriever do
  it "retrieves an organisation's data" do
    seller = create(:seller)
    xero_authorisation = create(:xero_authorisation, seller: seller)

    expect_any_instance_of(XeroApi::DebtorFetcher).to receive(:fetch)
    expect_any_instance_of(XeroApi::OrganisationFetcher).to receive(:fetch)
    expect_any_instance_of(XeroApi::InvoiceFetcher).to receive(:fetch)
    expect_any_instance_of(XeroApi::PayableFetcher).to receive(:fetch)
    expect_any_instance_of(XeroApi::VendorFetcher).to receive(:fetch)
    expect_any_instance_of(XeroApi::BankDetailsFetcher).to receive(:fetch)
    XeroApi::DataRetriever.new(xero_authorisation, seller).call
  end
end
