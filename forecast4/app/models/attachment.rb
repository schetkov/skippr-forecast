class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  validates :file_id, :file_name, :file_type, presence: true

  enum file_type: [
    :misc,
    :balance_sheet,
    :profit_and_loss,
    :aged_payable_report,
    :ageing_debtor_report,
    :drivers_license,
    :credit_report,
    :sales_agreement,
    :customer_receipt,
    :invoice_document,
    :purchase_order,
    :ppsr,
    :notice_of_assignment,
    :letter_from_accountant,
    :afsl,
    :financial_statements,
    :bank_statements
  ]

  def self.ordered
    order(created_at: :desc)
  end
end
