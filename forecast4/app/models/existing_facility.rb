class ExistingFacility < ActiveRecord::Base
  belongs_to :seller_company

  validates :name, :amount, presence: true
end
