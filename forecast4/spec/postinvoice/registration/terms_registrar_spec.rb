require "rails_helper"

describe Registration::TermsRegistrar do
  context "validations" do
    it { should validate_presence_of(:directors_name) }
    it { should validate_presence_of(:directors_email) }
    it { should validate_presence_of(:directors_address) }
    it { should validate_presence_of(:drivers_license_number) }
    it { should validate_presence_of(:dob_day) }
    it { should validate_presence_of(:dob_month) }
    it { should validate_presence_of(:dob_year) }
    it { should allow_value("valid@example.com").for(:directors_email) }
    it { should_not allow_value("invalid").for(:directors_email) }
  end

  describe "#call" do
    context "valid params" do
      it "registers the terms acceptance for a Seller as part of the wizard" do
        seller = create(:seller)

        Registration::TermsRegistrar.new(
          terms_params.merge(seller_id: seller.id)
        ).call
        company = seller.seller_company.reload

        expect(company.directors_name).to eq "Bob Smith"
        expect(company.directors_address).to eq "101 Address, Sydney, Australia"
        expect(company.directors_email).to eq "bob@example.com"
        expect(seller.reload.drivers_license_number).to eq "123456"
        expect(seller.reload.dob).to eq Time.zone.parse("2-12-1985")
      end

      def terms_params
        {
          "directors_name" => "Bob Smith",
          "directors_address" => "101 Address, Sydney, Australia",
          "directors_email" => "bob@example.com",
          "dob_day" => "2",
          "dob_month" => "12",
          "dob_year" => "1985",
          "drivers_license_number" => "123456"
        }
      end
    end

    context "invalid params" do
      it "registers the terms acceptance for a Seller as part of the wizard" do
        seller = create(:seller)

        terms_registration = Registration::TermsRegistrar.new(
          invalid_terms_params.merge(seller_id: seller.id)
        ).call

        expect(terms_registration).not_to be_valid
        expect(terms_registration.errors.full_messages).to include "Date of birth is invalid"
      end

      def invalid_terms_params
        {
          "directors_name" => "Bob Smith",
          "directors_address" => "101 Address, Sydney, Australia",
          "directors_email" => "bob@example.com",
          "dob_day" => "2",
          "dob_month" => "24",
          "dob_year" => "1985",
          "drivers_license_number" => "123456"
        }
      end
    end
  end
end
