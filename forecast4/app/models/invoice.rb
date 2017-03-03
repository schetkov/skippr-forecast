class Invoice < ActiveRecord::Base
  include Workflow

  belongs_to :buyer
  belongs_to :debtor
  belongs_to :seller
  belongs_to :trade

  has_one :rating
  has_many :attachments, as: :attachable

  has_many :scenario_invoices
  has_many :scenarios, through: :scenario_invoices

  workflow do
    state :pending do
      event :select, transition_to: :selected
    end
    state :selected do
      event :approve, transition_to: :approved
    end
    state :approved do
      event :sold, transition_to: :sold
    end
    state :sold do
      event :funded, transition_to: :funded
    end
    state :funded do
      event :repaid, transition_to: :repaid
    end
    state :repaid
  end

  delegate :funded_on, to: :trade, allow_nil: true

  validate :uniq_anticipated_pay_date,
           :uniq_due_date, on: :create

  validates :invoice_no,
            :face_value,
            :date,
            :due_date,
            :anticipated_pay_date, presence: true

  validates :invoice_no, uniqueness: { scope: :seller_id }

  def self.active
    with_approved_state.where('due_date > ?', Time.zone.now)
  end

  def self.available_for_trade
    available_invoices + unconfirmed_trade_invoices
  end

  def self.available_invoices
    active.
      where("date > ?", (Date.current - 30.days)).
      where(trade_id: nil)
  end

  def self.unconfirmed_trade_invoices
    joins(:trade).merge(Trade.unconfirmed)
  end

  def self.awaiting_approval
    where(workflow_state: ["pending", "selected"]).
      where("due_date > ?", Time.zone.now).
      order(updated_at: :desc)
  end

  def self.traded
    joins(:trade).merge(Trade.confirmed)
  end

  def self.payables
    where(xero_type: 'ACCPAY')
  end

  def self.receivables
    where(xero_type: 'ACCREC')
  end

  def potential_buyers
    # TODO: This can be improved!!
    buyer_ids = Mandate.where(debtor_id: debtor_id).pluck(:buyer_id)
    Buyer.where(id: buyer_ids)
  end

  def invoice_document
    attachments.invoice_document.last
  end

  def purchase_order_files
    attachments.purchase_order
  end

  def ppsrs
    attachments.ppsr
  end

  def notice_of_assignments
    attachments.notice_of_assignment
  end

  def advance_amount_in_dollars
    face_value * rating.advance_amount
  end

  def discount_fee_in_dollars
    advance_amount_in_dollars * thirty_day_discount_rate
  end

  def todays_discount_fee_in_dollars
    advance_amount_in_dollars * todays_discount_rate
  end

  def net_advance_amount
    advance_amount_in_dollars - seller_exchange_fee
  end

  def payment_residual
    face_value -
      advance_amount_in_dollars -
      discount_fee_in_dollars
  end

  def expired?
    date < (Date.current - 30.days)
  end

  def seller_exchange_fee
    seller.exchange_fee.to_f * face_value
  end

  def buyer_exchange_fee
    Preference.buyer_exchange_fee * face_value
  end

  private

  def thirty_day_discount_rate
    if paid_on && trade.funded_on
      rating.discount_rate * (actual_payment_period / 30.00)
    elsif trade && trade.funded_on
      rating.discount_rate * (estimated_payment_period / 30.00)
    else
      rating.discount_rate * (anticipated_payment_period / 30.00)
    end
  end

  def todays_discount_rate
    rating.discount_rate * (todays_payment_period / 30.00)
  end

  def actual_payment_period
    (paid_on - trade.funded_on).to_i
  end

  def todays_payment_period
    (Date.current - trade.funded_on).to_i
  end

  def estimated_payment_period
    if anticipated_pay_date
      (anticipated_pay_date - trade.funded_on).to_i
    else
      (due_date - trade.funded_on).to_i
    end
  end

  def anticipated_payment_period
    if anticipated_pay_date
      (anticipated_pay_date - Date.current).to_i
    else
      (due_date - Date.current).to_i
    end
  end

  def uniq_anticipated_pay_date
    if anticipated_pay_date && anticipated_pay_date == date
      errors.add :invoice, 'date and anticipated pay date cannot be the same'
    end
  end

  def uniq_due_date
    if due_date && due_date == date
      errors.add :invoice, 'date and due date cannot be the same'
    end
  end
end
