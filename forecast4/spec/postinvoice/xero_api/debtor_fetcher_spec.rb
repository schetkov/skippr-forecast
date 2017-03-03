require "rails_helper"

describe XeroApi::DebtorFetcher do
  before(:each) do
    allow_any_instance_of(Debtors::InvoiceAssignor).to receive(:call).
      and_return(true)
    allow_any_instance_of(Debtors::AgedReceivablesCalculator).to receive(:call).
      and_return(true)
  end

  it "fetches all debtors from Xero and creates new debtors" do
    xero_contact = double("contact", all: contacts)
    fake_xero_client = double("fake xero client", "Contact": xero_contact)
    seller = create(:seller)
    create(:invoice,
           debtor_id: nil,
           invoice_contact_id: "565acaa9-e7f3-4fbf-80c3-16b081ddae10",
           seller: seller)

    expect {
      XeroApi::DebtorFetcher.new(fake_xero_client, seller).fetch
    }.to change{ Debtor.count }.by(1)
  end

  it "uses xero response to create new debtors" do
    xero_contact = double("contact", all: contacts)
    fake_xero_client = double("fake xero client", "Contact": xero_contact)
    seller = create(:seller)
    create(:invoice,
           debtor_id: nil,
           invoice_contact_id: "565acaa9-e7f3-4fbf-80c3-16b081ddae10",
           seller: seller)

    XeroApi::DebtorFetcher.new(fake_xero_client, seller).fetch

    debtor = Debtor.first
    expect(debtor.legal_business_name).to eq "Southside Office Supplies"
    expect(debtor.contact_id).to eq "565acaa9-e7f3-4fbf-80c3-16b081ddae10"
    expect(debtor.contact_status).to eq "ACTIVE"
    expect(debtor.contact_email).to eq nil
    expect(debtor.account_number).to eq nil
    expect(debtor.tax_number).to eq nil
    expect(debtor.addresses).to eq addresses
    expect(debtor.phones).to eq phones
    expect(debtor.seller).to eq seller
    expect(debtor.seller_company).to eq seller.seller_company
  end

  it "updates existing debtors from xero response" do
    xero_contact = double("contact", all: contacts)
    fake_xero_client = double("fake xero client", "Contact": xero_contact)
    seller = create(:seller)
    create(:invoice,
           debtor_id: nil,
           invoice_contact_id: "565acaa9-e7f3-4fbf-80c3-16b081ddae10",
           seller: seller)
    debtor = create(:debtor,
                    seller: seller,
                    contact_id: "565acaa9-e7f3-4fbf-80c3-16b081ddae10",
                    contact_status: "ARCHIVED")

    XeroApi::DebtorFetcher.new(fake_xero_client, seller).fetch

    expect(debtor.reload.contact_status).to eq "ACTIVE"
  end

  def addresses
    [{"address_type"=>"POBOX"}, {"address_type"=>"STREET"}]
  end

  def phones
    [
      {"phone_type"=>"DDI"},
      {"phone_type"=>"DEFAULT"},
      {"phone_type"=>"FAX"},
      {"phone_type"=>"MOBILE"}
    ]
  end

  def contacts
    fake_contact_response.inject([]) do |result, element|
      result << Hashie::Mash.new(element)
    end
  end

  def fake_contact_response
    JSON.parse(
      File.open(
        "spec/" + "support/" + "fixtures/" + "contacts.json", "rb"
      ).read
    )
  end
end
