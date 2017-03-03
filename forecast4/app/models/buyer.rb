class Buyer < ActiveRecord::Base
  include Workflow

  has_many :attachments, as: :attachable
  has_many :debtors, through: :invoices
  has_many :fund_statements
  has_many :invoices
  has_many :mandates
  has_one :buyer_company
  has_one :user, as: :userable

  accepts_nested_attributes_for :user, :buyer_company

  delegate :name, :email, to: :user
  delegate :name, :phone_number, to: :buyer_company, prefix: true

  workflow do
    state :new do
      event :confirm, transitions_to: :confirmed
    end
    state :confirmed do
      event :complete, transitions_to: :completed
    end
    state :completed do
      event :approve, transitions_to: :approved
    end
    state :approved
  end

  def self.ordered
    order(created_at: :desc).limit(10)
  end

  def approved_invoices
    invoices.with_approved_state
  end

  def sold_invoices
    invoices.with_sold_state
  end

  def funded_invoices
    invoices.with_funded_state
  end

  def repaid_invoices
    invoices.with_repaid_state
  end

  def afsl
    attachments.afsl.last
  end

  def letter_from_accountant
    attachments.letter_from_accountant.last
  end

  def welcome_notification!
    Mailer.buyer_welcome_notification(self).deliver_now
  end

  def approval_notification!
    Mailer.buyer_approval_notification(self).deliver_now
  end

  def payment_status_notification!(invoice)
    Mailer.buyer_payment_status_notification(self, invoice).deliver_now
  end

  def incomplete?
    incomplete_states.include? current_state.name
  end

  def latest_fund_statement
    fund_statements.last
  end

  def find_relevant_mandate(invoice)
    mandates.where(debtor: invoice.debtor).last
  end

  private

  def upfront_payment(auction)
    auction.total_face_value * (auction.winning_bid.advance_amount.to_f / 100)
  end

  def incomplete_states
    [:new, :confirmed, :awaiting_approval]
  end
end
