class DebtorTerms < ActiveRecord::Base
  belongs_to :seller_company

  validates :warranties,
            :progressive_billing,
            :return_rights,
            :consignment_basis,
            :discounts, presence: true
end
