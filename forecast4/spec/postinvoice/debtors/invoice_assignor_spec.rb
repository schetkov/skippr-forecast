require "rails_helper"

describe Debtors::InvoiceAssignor do
  it "assigns a debtor to the relevant invoice" do
    invoice = create(:invoice, invoice_contact_id: "12345", debtor_id: nil)
    other_invoice = create(:invoice, invoice_contact_id: "54321", debtor_id: nil)
    debtor = create(:debtor, contact_id: "12345")

    Debtors::InvoiceAssignor.new(debtor).call

    expect(invoice.reload.debtor).to eq debtor
    expect(other_invoice.reload.debtor).to eq nil
  end
end
