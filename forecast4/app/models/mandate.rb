class Mandate < ActiveRecord::Base
  belongs_to :buyer
  belongs_to :debtor
end
