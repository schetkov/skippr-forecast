require "rails_helper"

describe Analytics::AnalyticsTracker do
  describe "#track_user_creation" do
    it "notifies AnalyticsRuby when a user is created" do
      allow(AnalyticsRuby).to receive(:track)
      user = build_stubbed(:user)

      analytics = Analytics::AnalyticsTracker.new(user)
      analytics.track_user_creation

      expect(AnalyticsRuby).to have_received(:track).with(
        user_id: user.id,
        event: "Create User"
      )
    end
  end

  describe "#track_user_sign_in" do
    it "notifies AnalyticsRuby of a user signing in" do
      allow(AnalyticsRuby).to receive(:track)
      user = build_stubbed(:user)
      seller = build_stubbed(:seller, accounting_platform: "Xero")

      analytics = Analytics::AnalyticsTracker.new(user)
      analytics.track_user_sign_in(seller)

      expect(AnalyticsRuby).to have_received(:track).with(
        user_id: user.id,
        event: "Sign In User",
        properties: {
          xero_user: "true"
        }
      )
    end
  end

  context "Wizard" do
    describe "#track_business_registration" do
      it "notifies AnalyticsRuby when user completes business registration" do
        allow(AnalyticsRuby).to receive(:track)
        user = build_stubbed(:user)

        analytics = Analytics::AnalyticsTracker.new(user)
        analytics.track_business_registration

        expect(AnalyticsRuby).to have_received(:track).with(
          user_id: user.id,
          event: "Business Registration"
        )
      end
    end

    describe "#track_customer_registration_with_xero" do
      it "notifies AnalyticsRuby when user connects to Xero" do
        allow(AnalyticsRuby).to receive(:track)
        user = build_stubbed(:user)

        analytics = Analytics::AnalyticsTracker.new(user)
        analytics.track_customer_registration_with_xero

        expect(AnalyticsRuby).to have_received(:track).with(
          user_id: user.id,
          event: "Customer Registration with Xero"
        )
      end
    end

    describe "#track_customer_registration" do
      it "notifies AnalyticsRuby when user completes customer registration" do
        allow(AnalyticsRuby).to receive(:track)
        user = build_stubbed(:user)

        analytics = Analytics::AnalyticsTracker.new(user)
        analytics.track_customer_registration

        expect(AnalyticsRuby).to have_received(:track).with(
          user_id: user.id,
          event: "Customer Registration"
        )
      end
    end

    describe "#track_terms_registration" do
      context "accepted terms" do
        it "notifies AnalyticsRuby when user completes terms registration" do
          allow(AnalyticsRuby).to receive(:track)
          user = build_stubbed(:user)

          analytics = Analytics::AnalyticsTracker.new(user)
          analytics.track_terms_registration

          expect(AnalyticsRuby).to have_received(:track).with(
            user_id: user.id,
            event: "Terms Registration"
          )
        end
      end

      context "did not accept terms" do
        it "notifies AnalyticsRuby when user completes terms registration" do
          allow(AnalyticsRuby).to receive(:track)
          user = build_stubbed(:user)

          analytics = Analytics::AnalyticsTracker.new(user)
          analytics.track_terms_registration

          expect(AnalyticsRuby).to have_received(:track).with(
            user_id: user.id,
            event: "Terms Registration"
          )
        end
      end
    end
  end

  describe "#track_debtor_registration" do
    it "notifies AnalyticsRuby when user registers a debtor/customer" do
      allow(AnalyticsRuby).to receive(:track)
      user = build_stubbed(:user)

      analytics = Analytics::AnalyticsTracker.new(user)
      analytics.track_debtor_registration

      expect(AnalyticsRuby).to have_received(:track).with(
        user_id: user.id,
        event: "Create Customer"
      )
    end
  end

  describe "#track_invoice_registration" do
    it "notifies AnalyticsRuby when user registers an invoice" do
      allow(AnalyticsRuby).to receive(:track)
      user = build_stubbed(:user)

      analytics = Analytics::AnalyticsTracker.new(user)
      analytics.track_invoice_registration

      expect(AnalyticsRuby).to have_received(:track).with(
        user_id: user.id,
        event: "Create Invoice"
      )
    end
  end

  describe "#track_invoice_submission" do
    it "notifies AnalyticsRuby when user submits invoice for approval" do
      allow(AnalyticsRuby).to receive(:track)
      user = build_stubbed(:user)

      analytics = Analytics::AnalyticsTracker.new(user)
      analytics.track_invoice_submission

      expect(AnalyticsRuby).to have_received(:track).with(
        user_id: user.id,
        event: "Invoice Submitted For Approval"
      )
    end
  end

  describe "#track_trade_preview" do
    it "notifies AnalyticsRuby when user begins trade process" do
      allow(AnalyticsRuby).to receive(:track)
      user = build_stubbed(:user)
      invoice_ids = [create(:invoice).id, create(:invoice).id]

      analytics = Analytics::AnalyticsTracker.new(user)
      analytics.track_trade_preview(invoice_ids)

      expect(AnalyticsRuby).to have_received(:track).with(
        user_id: user.id,
        event: "Preview Trade",
        properties: {
          invoices: invoice_ids.join(", ")
        }
      )
    end
  end

  describe "#track_trade_preview" do
    it "notifies AnalyticsRuby when user creates/executes a trade" do
      allow(AnalyticsRuby).to receive(:track)
      user = build_stubbed(:user)

      analytics = Analytics::AnalyticsTracker.new(user)
      analytics.track_trade_creation

      expect(AnalyticsRuby).to have_received(:track).with(
        user_id: user.id,
        event: "Create Trade"
      )
    end
  end
end
