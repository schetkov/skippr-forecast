require "rails_helper"

describe XeroApi::BankDetailsFetcher do
  it "fetches a Xero user's bank details via the API" do
    xero_account = double("account", all: account)
    fake_xero_client = double("fake xero client", "Account": xero_account)
    seller = create(:seller)

    XeroApi::BankDetailsFetcher.new(fake_xero_client, seller).fetch
    bank_details = seller.seller_company.bank_details

    expect(bank_details.account_name).to eq "Ralph's Widgets"
    expect(bank_details.account_number).to eq "87654321"
    expect(bank_details.bsb_number).to eq "123456"
  end

  it "doesn't fetch a Xero user's bank details if they don't have one" do
    xero_account = double("account", all: [])
    fake_xero_client = double("fake xero client", "Account": xero_account)
    seller = create(:seller)

    XeroApi::BankDetailsFetcher.new(fake_xero_client, seller).fetch

    expect(seller.seller_company.bank_details).to eq nil
  end

  def account
    [Hashie::Mash.new(fake_account_response.first)]
  end

  def fake_account_response
    JSON.parse(
      File.open(
        "spec/" + "support/" + "fixtures/" + "account.json", "rb"
      ).read
    )
  end
end
