class User < ActiveRecord::Base
  include Clearance::User

  belongs_to :userable, polymorphic: true

  validates :name, presence: true
  validates :account_type, presence: true, on: :create

  validate :password_complexity

  enum account_type: [:buyer, :seller, :admin]

  def seller
    if userable_type == "Seller"
      self.userable
    end
  end

  def buyer
    if userable_type == "Buyer"
      self.userable
    end
  end

  def password_complexity
    if password.present? && !password.match(/^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/)
      errors.add :password, "must include at least one lowercase letter, one uppercase letter, and one digit."
    end
  end
end
