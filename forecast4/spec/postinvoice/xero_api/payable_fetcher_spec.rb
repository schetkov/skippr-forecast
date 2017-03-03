require "rails_helper"

describe XeroApi::PayableFetcher do
  it "fetches account receivable invoices from Xero and creates new records" do
    seller = create(:seller)
    payable = double("payable", all: invoices)
    fake_xero_client = double("fake xero client", "Invoice": payable)

    expect {
      XeroApi::PayableFetcher.new(fake_xero_client, seller).fetch
    }.to change{ Payable.count }.by(1)
  end

  it "uses xero response to create new invoices" do
    payable = double("payable", all: invoices)
    fake_xero_client = double("fake xero client", "Invoice": payable)
    seller = create(:seller)

    XeroApi::PayableFetcher.new(fake_xero_client, seller).fetch

    payable = Payable.first
    expect(payable.invoice_no).to eq "ORC1005"
    expect(payable.face_value).to eq 1550
    expect(payable.date).not_to eq nil
    expect(payable.due_date).not_to eq nil
    expect(payable.anticipated_pay_date).not_to eq nil
    expect(payable.invoice_xero_id).to eq "b75b3928-ab72-4424-8b93-9cdbbde4cd72"
    expect(payable.invoice_contact_id).to eq "565acaa9-e7f3-4fbf-80c3-16b081ddae10"
    expect(payable.reference).to eq ""
    expect(payable.xero_type).to eq "ACCPAY"
    expect(payable.xero_status).to eq "PAID"
    expect(payable.total_tax).to eq 50
    expect(payable.sub_total).to eq 1500
    expect(payable.amount_due).to eq 0
    expect(payable.amount_paid).to eq 0
    expect(payable.amount_credited).to eq 550
    expect(payable.updated_date_utc).not_to eq nil
    expect(payable.currency_code).to eq "AUD"
    expect(payable.seller).to eq seller
  end

  # NOTE: Not sure about this spec. Commenting out for now.
  #it "updates an existing payable from xero response" do
    #payable = double("payable", all: invoices)
    #fake_xero_client = double("fake xero client", "Invoice": payable)
    #seller = create(:seller, :with_company)
    #payable = create(:payable,
                     #invoice_xero_id: "b75b3928-ab72-4424-8b93-9cdbbde4cd72",
                     #xero_status: "UNPAID",
                     #seller: seller)

    #XeroApi::InvoiceFetcher.new(fake_xero_client, seller).fetch

    #expect(payable.reload.xero_status).to eq "PAID"
  #end

  def invoices
    invoices = fake_invoice_response.inject([]) do |result, element|
      result << Hashie::Mash.new(element)
    end

    # Use Ruby dates instead of strings in the JSON response
    [
      invoices.first.merge!(
        date: 1.week.ago,
        due_date: 25.days.from_now,
        updated_date_utc: 5.days.ago,
        expected_payment_date: 30.days.from_now
      )
    ]
  end

  def fake_invoice_response
    # Create a debtor with a matching contact_id for the purposes of our tests
    FactoryGirl.create(:debtor, contact_id: "571a2414-81ff-4f8f-8498-d91d83793131")

    JSON.parse(
      File.open(
        "spec/" + "support/" + "fixtures/" + "payables.json", "rb"
      ).read
    )
  end
end
