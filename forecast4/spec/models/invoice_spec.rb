require 'rails_helper'

describe Invoice do
  it 'has a valid factory' do
    expect(build(:invoice)).to be_valid
  end

  context "associations" do
    it { should have_many(:attachments) }
    it { should have_one(:rating) }
    it { should belong_to(:debtor) }
    it { should belong_to(:seller) }
    it { should belong_to(:buyer) }
    it { should belong_to(:trade) }
  end

  context "delegations" do
    it { should delegate_method(:funded_on).to(:trade) }
  end

  context "validations" do
    it { should validate_presence_of(:invoice_no) }
    it { should validate_presence_of(:face_value) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:due_date) }
    it { should validate_presence_of(:anticipated_pay_date) }
  end

  describe "#invoice_document" do
    it "returns the last invoice_document attachment for the invoice" do
      invoice = create(:invoice)
      create(:attachment, :invoice_document, attachable: invoice)

      invoice_document = invoice.invoice_document

      expect(invoice_document.file_type).to eq "invoice_document"
      expect(invoice_document.attachable_id).to eq invoice.id
    end
  end

  describe "#purchase_order_files" do
    it "returns purchase order files for the invoice" do
      invoice = create(:invoice)
      purchase_order = create(:attachment,
                              :purchase_order,
                              attachable: invoice)
      invoice_document = create(:attachment,
                                :invoice_document,
                                attachable: invoice)

      purchase_order_files = invoice.purchase_order_files

      expect(purchase_order_files).to include purchase_order
      expect(purchase_order_files).not_to include invoice_document
    end
  end

  describe "#ppsrs" do
    it "returns ppsrs for the invoice" do
      invoice = create(:invoice)
      ppsr = create(:attachment,
                    :ppsr,
                    attachable: invoice)
      invoice_document = create(:attachment,
                                :invoice_document,
                                attachable: invoice)

      ppsr_files = invoice.ppsrs

      expect(ppsr_files).to include ppsr
      expect(ppsr_files).not_to include invoice_document
    end
  end

  describe "#notice_of_assignments" do
    it "returns notice of assignments for the invoice" do
      invoice = create(:invoice)
      notice_of_assignment = create(:attachment,
                                    :notice_of_assignment,
                                    attachable: invoice)
      invoice_document = create(:attachment,
                                :invoice_document,
                                attachable: invoice)

      notice_of_assignments = invoice.notice_of_assignments

      expect(notice_of_assignments).to include notice_of_assignment
      expect(notice_of_assignments).not_to include invoice_document
    end
  end
end

describe Invoice, 'custom validations' do
  context '#uniq_anticipated_pay_date' do
    it 'rejects inovoices with same anticipated pay date and invoice date' do
      date = Date.current
      invoice = build(:invoice, anticipated_pay_date: date, date: date)

      expect(invoice).not_to be_valid
      expect(invoice.errors.full_messages).to include 'Invoice date and anticipated pay date cannot be the same'
    end
  end

  context '#uniq_due_date' do
    it 'rejects invoices with same due date and invoice date' do
      date = Date.current
      invoice = build(:invoice, due_date: date, date: date)

      expect(invoice).not_to be_valid
      expect(invoice.errors.full_messages).to include 'Invoice date and due date cannot be the same'
    end
  end

  context '#uniq_invoice_no' do
    it 'rejects an invoice not containng a unique invoice no scoped to user' do
      seller = create(:seller)
      invoice = create(:invoice, invoice_no: '123', seller: seller)
      duplicate_invoice = build(:invoice, invoice_no: '123', seller: seller)

      expect(invoice).to be_valid
      expect(duplicate_invoice).not_to be_valid
    end
  end
end

describe Invoice, '.active' do
  it 'scopes invoices that are not past due date and have been approved' do
    active_invoice = create(:invoice, workflow_state: 'approved', due_date: Date.current + 3.days)
    inactive_invoice = create(:invoice, workflow_state: 'approved', due_date: Date.current - 3.days)
    pending_invoice = create(:invoice, workflow_state: 'pending', due_date: Date.current + 3.days)

    active_invoices = Invoice.active

    expect(active_invoices).to include active_invoice
    expect(active_invoices).not_to include inactive_invoice
    expect(active_invoices).not_to include pending_invoice
  end
end

describe Invoice, ".available_for_trade" do
  it "scopes invoices that are active and do not belong to a confirmed trade" do
    confirmed_trade = create(:trade, :confirmed)
    unconfirmed_trade = create(:trade)
    available_invoice = create(:invoice, :approved, trade: nil)
    another_available_invoice = create(:invoice, :approved, trade: unconfirmed_trade)
    unavailable_invoice = create(:invoice, :approved, trade: confirmed_trade)
    inactive_invoice = create(:invoice, :approved, trade: nil, due_date: Date.current - 3.days)

    available_invoices = Invoice.available_for_trade

    expect(available_invoices).to include available_invoice
    expect(available_invoices).to include another_available_invoice
    expect(available_invoices).not_to include unavailable_invoice
    expect(available_invoices).not_to include inactive_invoice
  end

  it "returns invoices which are no older than 30 days" do
    old_invoice = create(:invoice,
                         :approved,
                         due_date: (Date.current + 60.days),
                         trade: nil)

    travel 35.days do
      available_invoices = Invoice.available_for_trade

      expect(available_invoices).not_to include old_invoice
    end
  end
end

describe Invoice, ".available_invoices" do
  it "scopes invoices to active, not older than 30 days and do not belong to a trade" do
    trade = create(:trade, :confirmed)
    available_invoice = create(:invoice, :approved, trade: nil)
    unavailable_invoice = create(:invoice, :approved, trade: trade)

    available_invoices = Invoice.available_invoices

    expect(available_invoices).to include available_invoice
    expect(available_invoices).not_to include unavailable_invoice
  end
end

describe Invoice, ".unconfirmed_trade_invoices" do
  it "scopes invoices to trades which haven't been confirmed" do
    confirmed_trade = create(:trade, :confirmed)
    unconfirmed_trade = create(:trade)
    available_invoice = create(:invoice, :approved, trade: unconfirmed_trade)
    unavailable_invoice = create(:invoice, :approved, trade: confirmed_trade)

    available_invoices = Invoice.unconfirmed_trade_invoices

    expect(available_invoices).to include available_invoice
    expect(available_invoices).not_to include unavailable_invoice
  end
end

describe Invoice, ".awaiting_approval" do
  it "returns a collecion of invoices which are pending and active" do
    approved_invoice = create(:invoice, :active, workflow_state: "approved")
    pending_invoice = create(:invoice, :active, workflow_state: "pending")
    selected_invoice = create(:invoice, :active, workflow_state: "selected")
    old_pending_invoice = create(:invoice, :expired, workflow_state: "pending")

    invoices_awaiting_approval = Invoice.awaiting_approval

    expect(invoices_awaiting_approval).to include(pending_invoice)
    expect(invoices_awaiting_approval).to include(selected_invoice)
    expect(invoices_awaiting_approval).not_to include(
      [approved_invoice, old_pending_invoice]
    )
  end
end

describe Invoice, ".traded" do
  it "returns a collection of traded invoices" do
    trade = create(:trade, confirmed_at: DateTime.current)
    unconfirmed_trade = create(:trade, confirmed_at: nil)
    traded_invoice = create(:invoice, trade: trade)
    untraded_invoice = create(:invoice, trade_id: nil)
    unconfirmed_trade_invoice = create(:invoice, trade: unconfirmed_trade)

    traded_invoices = Invoice.traded

    expect(traded_invoices).to include traded_invoice
    expect(traded_invoices).not_to include untraded_invoice
    expect(traded_invoices).not_to include unconfirmed_trade_invoice
  end
end

describe Invoice, "#advance_amount_in_dollars" do
  it "returns the advance amount in dollars based on face value and rating" do
    invoice = create(:invoice, face_value: 10_000)
    create(:rating, advance_amount: 0.9, invoice: invoice)

    advance_amount = invoice.advance_amount_in_dollars

    expect(advance_amount).to eq 9_000
  end
end

describe Invoice, "#discount_fee_in_dollars" do
  it "calculates an estimated discount fee based on advance amount" do
    invoice = create(:invoice,
                     face_value: 10_000,
                     anticipated_pay_date: Date.current + 30.days)
    create(:rating, advance_amount: 0.9, discount_rate: 0.1, invoice: invoice)

    discount_fee = invoice.discount_fee_in_dollars

    expect(discount_fee).to eq 900
  end

  it "calculates the actual discount fee based on advance amount" do
    invoice = create(:invoice,
                     face_value: 10_000,
                     anticipated_pay_date: Date.current + 30.days,
                     paid_on: Date.current + 60.days)
    create(:rating, advance_amount: 0.9, discount_rate: 0.1, invoice: invoice)
    trade = create(:trade, funded_on: Date.current)
    trade.invoices << invoice

    discount_fee = invoice.discount_fee_in_dollars

    expect(discount_fee).to eq 1800
  end
end

describe Invoice, "#todays_discount_fee_in_dollars" do
  it "estimates the discount fee if it were paid today" do
    invoice = create(:invoice,
                     face_value: 10_000,
                     paid_on: nil)
    create(:rating, advance_amount: 0.9, discount_rate: 0.1, invoice: invoice)
    trade = create(:trade, funded_on: Date.current - 30.days)
    trade.invoices << invoice

    discount_fee = invoice.todays_discount_fee_in_dollars

    expect(discount_fee).to eq 900
  end
end

describe Invoice, "#net_advance_amount" do
  it "subtracts the seller exchange fee from the advance amount" do
    seller = create(:seller, exchange_fee: 0.01)
    invoice = create(:invoice, face_value: 10_000, seller: seller)
    create(:rating, advance_amount: 0.9, invoice: invoice)

    net_advance_amount = invoice.net_advance_amount

    expect(net_advance_amount).to eq 8_900
  end
end

describe Invoice, "#seller_exchange_fee" do
  it "multiplies the seller_exchange_fee with the invoices' face value" do
    seller = create(:seller, exchange_fee: 0.01)
    invoice = create(:invoice, face_value: 10_000, seller: seller)

    seller_exchange_fee = invoice.seller_exchange_fee

    expect(seller_exchange_fee).to eq 100
  end

  it "multiplies the buyer_exchange_fee with the invoices' face value" do
    create(:preference, buyer_exchange_fee: 0.01)
    invoice = create(:invoice, face_value: 10_000)

    buyer_exchange_fee = invoice.buyer_exchange_fee

    expect(buyer_exchange_fee).to eq 100
  end
end

describe Invoice, "#payment_residual" do
  it "calculates the residual from face value" do
    invoice = create(:invoice,
                     face_value: 10_000,
                     anticipated_pay_date: Date.current + 30.days)
    create(:rating, advance_amount: 0.9, discount_rate: 0.1, invoice: invoice)

    payment_residual = invoice.payment_residual

    expect(payment_residual).to eq 100
  end
end

describe Invoice, "#expired?" do
  it "is expired if invoice date is greater than 30 days" do
    invoice = build(:invoice, date: Date.current - 31.days)

    expect(invoice.expired?).to eq true
  end

  it "is not expired if invoice date is less than 30 days" do
    invoice = build(:invoice, date: Date.current - 29.days)

    expect(invoice.expired?).to eq false
  end
end

describe Invoice, "#potential_buyers" do
  it "returns a collection of buyers who are potential investors" do
    debtor = create(:debtor)
    buyer = create(:buyer)
    create(:mandate, buyer: buyer, debtor: debtor)
    incorrect_buyer = create(:buyer)
    invoice = create(:invoice, debtor: debtor)

    buyers = invoice.potential_buyers

    expect(buyers).to include buyer
    expect(buyers).not_to include incorrect_buyer
  end
end
