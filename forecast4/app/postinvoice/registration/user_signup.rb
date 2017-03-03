module Registration
  class UserSignup
    include ActiveModel::Model

    attr_accessor(
      :name,
      :email,
      :company_name,
      :acn,
      :website,
      :phone_number,
      :password
    )

    validates :name,
              :email,
              :company_name,
              :acn,
              :website,
              :phone_number,
              :password, presence: true

    validates :email, email: { strict_mode: true }
    validate :email_is_unique, :password_complexity

    def call
      if self.valid?
        create_sign_up_models
      end
      self
    end

    def create_sign_up_models
      user
      seller
      seller_company
    end

    def user
      @user ||= Clearance.configuration.user_model.create(
        name: name,
        email: email,
        password: password,
        account_type: "seller",
      )
    end

    def seller
      @seller ||= Seller.create(user: user)
    end

    def seller_company
      @seller_company ||= seller.create_seller_company(
        name: company_name,
        acn: acn,
        website: website,
        phone_number: phone_number
      )
    end

    private

    def email_is_unique
      if User.where(email: email).any?
        errors.add(:email, "is already taken")
      end
    end

    def password_complexity
      if password.present? && !password.match(/^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/)
        errors.add :password, "must include at least one lowercase letter, one uppercase letter, and one digit."
      end
    end
  end
end
