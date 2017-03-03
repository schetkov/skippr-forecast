require "rails_helper"

describe Sessions::SessionRedirector, "#call" do
  it "redirects to business registration path" do
    seller = create(:seller, workflow_state: "business_registration")

    path = Sessions::SessionRedirector.new(seller.user).call

    expect(path).to eq "/wizard/business"
  end

  it "redirects to customer registration path" do
    seller = create(:seller, workflow_state: "customer_registration")

    path = Sessions::SessionRedirector.new(seller.user).call

    expect(path).to eq "/wizard/customers"
  end

  it "redirects to terms and conditions path" do
    seller = create(:seller, workflow_state: "terms_registration")

    path = Sessions::SessionRedirector.new(seller.user).call

    expect(path).to eq "/wizard/terms"
  end

  it "redirects to customer registration path" do
    seller = create(:seller, workflow_state: "completed")

    path = Sessions::SessionRedirector.new(seller.user).call

    expect(path).to eq "/dashboard"
  end

  it "redirects buyer when confirmed" do
    buyer = create(:buyer, workflow_state: "confirmed")

    path = Sessions::SessionRedirector.new(buyer.user).call

    expect(path).to eq "/"
  end

  it "redirects buyer to buyer dashboard" do
    buyer = create(:buyer, workflow_state: "approved")

    path = Sessions::SessionRedirector.new(buyer.user).call

    expect(path).to eq "/dealboard"
  end
end
