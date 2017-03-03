class Debtor < ActiveRecord::Base
  belongs_to :seller
  belongs_to :seller_company

  has_many :attachments, as: :attachable
  has_many :invoices, dependent: :destroy
  has_many :payables, dependent: :destroy

  enum status: [:pending, :approved]

  validate :minimum_relationship_start_date

  validates :legal_business_name, presence: true

  delegate :name, to: :seller, prefix: true
  delegate :name, to: :seller_company, prefix: true

  def credit_reports
    attachments.credit_report.ordered
  end

  def sales_agreements
    attachments.sales_agreement.ordered
  end

  def customer_receipts
    attachments.customer_receipt.ordered
  end

  def debtor_and_seller_company_name
    legal_business_name + " (#{seller_company_name})"
  end

  private

  def minimum_relationship_start_date
    if relationship_start_date && relationship_start_date >
      (Date.current - 1.year)
      errors.add :relationship_start_date, 'cannot be less than 1 year.'
    end
  end
end
