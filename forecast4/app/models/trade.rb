class Trade < ActiveRecord::Base
  belongs_to :seller

  has_many :invoices

  validates :total_face_value, :advance_amount, :discount_fee, presence: true

  def self.confirmed
    where("confirmed_at IS NOT NULL")
  end

  def self.unconfirmed
    where(confirmed_at: nil)
  end

  def residual
    total_face_value -
      advance_amount -
      discount_fee
  end

  def unfunded?
    funding_status == "Invoices Unfunded"
  end
end
