class BuyerCompany < ActiveRecord::Base
  belongs_to :buyer

  has_one :bank_details, as: :bankable
  has_one :accountant

  validates :name, presence: true

  def self.ordered
    order(created_at: :desc).limit(10)
  end
end
