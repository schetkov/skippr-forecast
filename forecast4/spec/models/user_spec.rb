require 'rails_helper'

describe User do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  context "associations" do
    it { should belong_to(:userable) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:account_type).on(:create) }
  end

  describe "custom password validation" do
    context "valid password" do
      it "requires a password to contain an uppercase, lowercase and a digit" do
        valid_user = build(:user, password: "Postinvoice2015")

        expect(valid_user).to be_valid
        expect(valid_user.errors.full_messages).to be_empty
      end
    end

    context "invalid password" do
      it "requires a password to contain an uppercase, lowercase and a digit" do
        invalid_user = build(:user, password: "bad-password")

        expect(invalid_user).not_to be_valid
        expect(invalid_user.errors.full_messages).to include "Password must include at least one lowercase letter, one uppercase letter, and one digit."
      end
    end
  end

  describe "#seller" do
    it "returns the seller which the user belongs to" do
      seller = create(:seller)
      user = create(:user, userable: seller)

      expect(user.seller).to eq seller
    end
  end

  describe "#buyer" do
    it "returns the buyer which the user belongs to" do
      buyer = create(:buyer)
      user = create(:user, userable: buyer)

      expect(user.buyer).to eq buyer
    end
  end
end
