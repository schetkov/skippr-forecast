require 'rails_helper'

RSpec.describe Radar::RulesController, type: :controller do

  let!(:seller) { create(:seller) }
  let!(:scenario) { create(:cash_flow_scenario, seller: seller) }

  before do
    sign_in seller
  end

  describe "#create" do
    it {
      post :create, cash_flow_rule: attributes_for(:cash_flow_rule), scenario_id: scenario.id
      expect(response.status).to eq 200
    }
  end

end
