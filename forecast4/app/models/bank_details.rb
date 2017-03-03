class BankDetails < ActiveRecord::Base
  belongs_to :bankable, polymorphic: true

  validates :account_name,
            :account_number,
            :bsb_number, presence: true
end
