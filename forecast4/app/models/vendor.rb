class Vendor < ActiveRecord::Base
  belongs_to :seller
  belongs_to :seller_company

  has_many :payables, dependent: :destroy

  enum status: [:pending, :approved]

  validates :legal_business_name, presence: true

  delegate :name, to: :seller, prefix: true
  delegate :name, to: :seller_company, prefix: true

end
