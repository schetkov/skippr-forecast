require "rails_helper"

describe Registration::UserSignup do
  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:company_name) }
    it { should validate_presence_of(:acn) }
    it { should validate_presence_of(:website) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:password) }
  end

  context "with valid params" do
    it "signs the user up" do
      sign_up_params = {
        "name" => "John Smith",
        "email" => "valid@example.com",
        "company_name" => "Company Ltd",
        "acn" => "123456",
        "website" => "www.website.com",
        "phone_number" => "987654321",
        "password" => "Foobar1234",
      }

      signup = Registration::UserSignup.new(sign_up_params).call

      expect(signup.user.name).to eq "John Smith"
      expect(signup.user.email).to eq "valid@example.com"
      expect(signup.seller.seller_company_name).to eq "Company Ltd"
      expect(signup.seller.seller_company_acn).to eq "123456"
      expect(signup.seller.seller_company_website).to eq "www.website.com"
      expect(signup.seller.seller_company_phone_number).to eq "987654321"
    end
  end

  context "with invalid params" do
    it "returns the signup object with errors" do
      sign_up_params = {
        "name" => "",
        "email" => "",
        "company_name" => "",
        "acn" => "",
        "website" => "",
        "phone_number" => "",
        "password" => "",
      }

      signup = Registration::UserSignup.new(sign_up_params).call
      error_messages = signup.errors.full_messages

      expect(error_messages).to include "Name can't be blank"
      expect(error_messages).to include "Email can't be blank"
      expect(error_messages).to include "Company name can't be blank"
      expect(error_messages).to include "Acn can't be blank"
      expect(error_messages).to include "Website can't be blank"
      expect(error_messages).to include "Phone number can't be blank"
      expect(error_messages).to include "Password can't be blank"
    end

    it "validates whether email is unique" do
      create(:user, email: "duplicate@example.com")
      sign_up_params = {
        "name" => "John Smith",
        "email" => "duplicate@example.com",
        "company_name" => "Company Ltd",
        "acn" => "123456",
        "website" => "www.website.com",
        "phone_number" => "987654321",
        "password" => "Foobar1234",
      }

      signup = Registration::UserSignup.new(sign_up_params).call
      error_messages = signup.errors.full_messages

      expect(error_messages).to include "Email is already taken"
    end
  end
end
