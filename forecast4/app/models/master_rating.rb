class MasterRating < ActiveRecord::Base
  validates :rating_value, :discount_rate, :advance_amount, presence: true
end
