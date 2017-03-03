require "rails_helper"

describe ApplicationController do
  describe "#current_seller" do
    it "returns a current_seller if current_user is a seller" do
      seller = create(:seller)
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(seller.user)

      current_seller = controller.current_seller

      expect(current_seller).to eq seller
    end

    it "returns nil if current_user is not a seller" do
      buyer = create(:buyer)
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(buyer.user)

      current_seller = controller.current_seller

      expect(current_seller).to eq nil
    end
  end

  describe "#current_buyer" do
    it "returns a current_buyer if current_user is a buyer" do
      buyer = create(:buyer)
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(buyer.user)

      current_buyer = controller.current_buyer

      expect(current_buyer).to eq buyer
    end

    it "returns nil if current_user is not a buyer" do
      seller = create(:seller)
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(seller.user)

      current_buyer = controller.current_buyer

      expect(current_buyer).to eq nil
    end
  end

  describe "#new_user_sign_up?" do
    it "returns true if seller is in :new state" do
      seller = create(:seller, workflow_state: "new")
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(seller.user)

      new_user = controller.new_user_sign_up?

      expect(new_user).to eq true
    end

    it "returns true if buyer is in :new state" do
      buyer = create(:buyer, workflow_state: "new")
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(buyer.user)

      new_user = controller.new_user_sign_up?

      expect(new_user).to eq true
    end

    it "returns false if seller is not in :new state" do
      seller = create(:seller, workflow_state: "completed")
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(seller.user)

      new_user = controller.new_user_sign_up?

      expect(new_user).to eq false
    end

    it "returns false if buyer is not in :new state" do
      buyer = create(:buyer, workflow_state: "completed")
      allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(buyer.user)

      new_user = controller.new_user_sign_up?

      expect(new_user).to eq false
    end
  end
end
