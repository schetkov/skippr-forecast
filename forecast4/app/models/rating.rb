class Rating < ActiveRecord::Base

  belongs_to :invoice

  validates :master_rating_value,
            :master_rating_applied_at,
            :discount_rate,
            :advance_amount, presence: true
end
