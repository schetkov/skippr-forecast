class Seller < ActiveRecord::Base
  include Workflow

  has_many :attachments, as: :attachable
  has_many :debtors
  has_many :vendors
  has_many :invoices, dependent: :destroy
  has_many :payables, dependent: :destroy
  has_many :trades
  has_many :xero_authorisations
  has_one :seller_company
  has_one :user, as: :userable

  accepts_nested_attributes_for :user, :seller_company

  validates :exchange_fee, presence: true

  delegate :name, :email, to: :user
  delegate :name,
           :website,
           :phone_number,
           :acn, to: :seller_company, prefix: true

  workflow do
    state :new do
      event :confirm, transitions_to: :business_registration
    end
    state :business_registration do
      event :business_registered, transitions_to: :customer_registration
    end
    state :customer_registration do
      event :customer_registered, transitions_to: :terms_registration
    end
    state :terms_registration do
      event :terms_registered, transitions_to: :completed
    end
    state :completed
  end

  def self.ordered
    order(created_at: :desc).limit(10)
  end

  def latest_misc_documents
    seller_company.attachments.misc.ordered
  end

  def latest_financial_statements
    seller_company.attachments.financial_statements.ordered
  end

  def latest_bank_statements
    seller_company.attachments.bank_statements.ordered
  end

  def credit_reports
    attachments.credit_report.ordered
  end

  def drivers_license
    attachments.drivers_license.last
  end

  def latest_invoices
    invoices.order(created_at: :desc)
  end

  def total_value_of_invoices_funded
    trades.confirmed.sum(:total_face_value)
  end

  def total_value_of_funding_available
    invoices_with_funding_available =
      invoices_with_trades_unconfirmed + invoices_without_trades

    invoices_with_funding_available.sum(&:face_value).ceil
  end

  def total_value_of_potential_funding_available
    invoices.awaiting_approval.sum(:face_value)
  end

  def welcome_notification!
    Mailer.seller_welcome_notification(self).deliver_now
  end

  def approval_notification!
    Mailer.seller_approval_notification(self).deliver_now
  end

  def payment_status_notification!(invoice)
    Mailer.seller_payment_status_notification(self, invoice).deliver_now
    # This method should be combined with the buyer's payment status notification.
    # Ultimately this needs to be extracted to a Notification class.
    invoice.touch(:payment_status_notification_sent)
  end

  def has_xero_authorisation?
    xero_authorisations.present?
  end

  def xero_user?
    accounting_platform == "Xero"
  end

  def cash_flow_user?
    self.is_cash_flow_user
  end

  def has_an_approved_invoice?
    invoices.available_for_trade.present?
  end

  def register_customer!
    if customer_registration?
      customer_registered!
    end
  end

  concerning :CashFlowTool do

    included do
      has_many :scenarios, class_name: CashFlowScenario
    end

    def default_sales_scenario
      scenarios.first_or_create(title: 'Default Scenario')
    end

  end

  private

  def invoices_with_trades_unconfirmed
    invoices.active.joins(:trade).where("trades.confirmed_at IS NULL").
      with_approved_state
  end

  def invoices_without_trades
    invoices.active.where(trade_id: nil).with_approved_state
  end

  def upfront_payment(auction)
    auction.total_face_value * (auction.winning_bid.advance_amount.to_f / 100)
  end
end
