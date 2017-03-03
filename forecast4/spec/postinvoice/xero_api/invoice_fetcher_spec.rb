require "rails_helper"

describe XeroApi::InvoiceFetcher do
  it "fetches account receivable invoices from Xero and creates new records" do
    seller = create(:seller)
    invoice = double("invoice", all: invoices)
    fake_xero_client = double("fake xero client", "Invoice": invoice)

    expect {
      XeroApi::InvoiceFetcher.new(fake_xero_client, seller).fetch
    }.to change{ Invoice.count }.by(1)
  end

  it "uses xero response to create new invoices" do
    invoice = double("invoice", all: invoices)
    fake_xero_client = double("fake xero client", "Invoice": invoice)
    seller = create(:seller)

    XeroApi::InvoiceFetcher.new(fake_xero_client, seller).fetch

    invoice = Invoice.first
    expect(invoice.invoice_no).to eq "ORC1005"
    expect(invoice.face_value).to eq 1550
    expect(invoice.date).not_to eq nil
    expect(invoice.due_date).not_to eq nil
    expect(invoice.anticipated_pay_date).not_to eq nil
    expect(invoice.invoice_xero_id).to eq "b75b3928-ab72-4424-8b93-9cdbbde4cd72"
    expect(invoice.invoice_contact_id).to eq "565acaa9-e7f3-4fbf-80c3-16b081ddae10"
    expect(invoice.reference).to eq ""
    expect(invoice.xero_type).to eq "ACCREC"
    expect(invoice.xero_status).to eq "PAID"
    expect(invoice.total_tax).to eq 50
    expect(invoice.sub_total).to eq 1500
    expect(invoice.amount_due).to eq 0
    expect(invoice.amount_paid).to eq 0
    expect(invoice.amount_credited).to eq 550
    expect(invoice.updated_date_utc).not_to eq nil
    expect(invoice.currency_code).to eq "AUD"
    expect(invoice.fully_paid_on_date).not_to eq nil
    expect(invoice.seller).to eq seller
  end

  it "updates an existing invoice from xero response" do
    invoice = double("invoice", all: invoices)
    fake_xero_client = double("fake xero client", "Invoice": invoice)
    seller = create(:seller)
    invoice = create(:invoice,
                     invoice_xero_id: "b75b3928-ab72-4424-8b93-9cdbbde4cd72",
                     xero_status: "UNPAID",
                     seller: seller)

    XeroApi::InvoiceFetcher.new(fake_xero_client, seller).fetch

    expect(invoice.reload.xero_status).to eq "PAID"
  end

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
        "spec/" + "support/" + "fixtures/" + "invoices.json", "rb"
      ).read
    )
  end
end
