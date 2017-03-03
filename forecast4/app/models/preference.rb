class Preference < ActiveRecord::Base
  validates :buyer_exchange_fee, :seller_exchange_fee, presence: true

  def self.seller_exchange_fee
    last.seller_exchange_fee
  end

  def self.buyer_exchange_fee
    last.buyer_exchange_fee
  end
end
