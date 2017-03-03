class Payable < ActiveRecord::Base
  belongs_to :seller
  belongs_to :debtor
  belongs_to :vendor
  #belongs_to :trade

  has_one :rating
  has_many :attachments, as: :attachable

  has_many :scenario_payables
  has_many :scenarios, through: :scenario_payables

  # NOTE: Validate for `invoice_no`, if it really is required.
  # Xero is not providing it at the momemnt.
  validates :face_value,
            :date,
            :due_date, presence: true

  validates :invoice_xero_id, uniqueness: { scope: :seller_id }
end
