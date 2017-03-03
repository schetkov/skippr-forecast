module Registration
  class TermsRegistrar
    include ActiveModel::Model

    validate :correct_date_of_birth, if: :date_of_birth_present?
    validates :directors_name,
              :directors_email,
              :directors_address,
              :drivers_license_number,
              :dob_day,
              :dob_month,
              :dob_year,
              presence: true

    validates :directors_email, email: { strict_mode: true }

    attr_accessor(
      :directors_name,
      :directors_address,
      :directors_email,
      :drivers_license_number,
      :dob_day,
      :dob_month,
      :dob_year,
      :seller_id
    )

    def call
      if self.valid?
        update_company_with_directors_information
        update_sellers_information
        self
      else
        self
      end
    end

    private

    def seller
      @seller ||= Seller.find(seller_id)
    end

    def correct_date_of_birth
      Time.zone.parse(date_string)
    rescue ArgumentError
      errors.add :date_of_birth, "is invalid"
    end

    def date_of_birth_present?
      date_string.present?
    end

    def update_company_with_directors_information
      seller.seller_company.update(
        directors_name: directors_name,
        directors_address: directors_address,
        directors_email: directors_email
      )
    end

    def update_sellers_information
      seller.update(
        drivers_license_number: drivers_license_number,
        dob: date_of_birth
      )
    end

    def date_of_birth
      Time.zone.parse(date_string)
    end

    def date_string
      [dob_day, dob_month, dob_year].join("-")
    end
  end
end
