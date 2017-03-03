require "rails_helper"

describe XeroApi::OrganisationFetcher do
  it "updates a seller company with organisation data from Xero" do
    xero_organisation = double("organisation", all: organisation)
    fake_xero_client = double("fake xero client", "Organisation": xero_organisation)
    seller = create(:seller)
    company = create(:seller_company,
                     addresses: old_addresses,
                     seller: seller)

    XeroApi::OrganisationFetcher.new(fake_xero_client, seller).fetch

    expect(company.reload.addresses).to eq addresses
  end

  def addresses
    [
      {
        "address_type"=>"POBOX",
        "address_line1"=>"23 Main Street",
        "city"=>"Marineville",
        "region"=>"NSW",
        "postal_code"=>"2000"
      }
    ]
  end

  def old_addresses
    [
      {
        "address_type"=>"POBOX",
        "address_line1"=>"50 Old Street",
        "city"=>"Marineville",
        "region"=>"NSW",
        "postal_code"=>"2000"
      }
    ]
  end

  def phones
    [
      {
        "phone_type"=>"OFFICE",
        "phone_number"=>"99998888",
        "phone_area_code"=>"02"
      }
    ]
  end

  def organisation
    [Hashie::Mash.new(fake_organisation_response.first)]
  end

  def fake_organisation_response
    JSON.parse(
      File.open(
        "spec/" + "support/" + "fixtures/" + "organisation.json", "rb"
      ).read
    )
  end
end
