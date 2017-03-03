class SellerCompany < ActiveRecord::Base
  belongs_to :seller

  has_many :attachments, as: :attachable
  has_many :existing_facilities
  has_one :bank_details, as: :bankable
  has_one :debtor_terms
  has_one :financials

  validates :name, presence: true

  def self.ordered
    order(created_at: :desc).limit(10)
  end

  def financial_statements
    attachments.financial_statements.ordered
  end

  def bank_statements
    attachments.bank_statements.ordered
  end

  def invoice_documents
    attachments.invoice_document.ordered
  end

  def misc_documents
    attachments.misc.ordered
  end
end
