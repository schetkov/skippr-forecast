module Analytics
  class AnalyticsTracker
    class_attribute :backend
    self.backend = AnalyticsRuby

    def initialize(user, client_id = nil)
      @user = user
      @client_id = client_id
    end

    def track_user_creation
      identify
      track(user_id: user.id, event: "Create User")
    end

    def track_user_sign_in(seller)
      # identify
      track(
        user_id: user.id,
        event: "Sign In User",
        properties: {
          xero_user: seller && seller.xero_user? ? "true" : "false"
        }
      )
    end

    def track_business_registration
      track(user_id: user.id, event: "Business Registration")
    end

    def track_customer_registration_with_xero
      track(user_id: user.id, event: "Customer Registration with Xero")
    end

    def track_customer_registration
      track(user_id: user.id, event: "Customer Registration")
    end

    def track_terms_registration
      track(
        user_id: user.id,
        event: "Terms Registration"
      )
    end

    def track_debtor_registration
      track(user_id: user.id, event: "Create Customer")
    end

    def track_invoice_registration
      track(user_id: user.id, event: "Create Invoice")
    end

    def track_invoice_submission
      track(user_id: user.id, event: "Invoice Submitted For Approval")
    end

    def track_trade_preview(invoice_ids)
      track(
        user_id: user.id,
        event: "Preview Trade",
        properties: {
          invoices: invoice_ids.join(", ")
        }
      )
    end

    def track_trade_creation
      track(user_id: user.id, event: "Create Trade")
    end

    private

    attr_reader :user, :seller, :client_id

    def identify
      backend.identify(identify_params)
    end

    def identify_params
      {
        user_id: user.id,
        traits: user_traits
      }
    end

    def user_traits
      {
        email: user.email,
        name: user.name,
      }.reject { |key, value| value.blank? }
    end

    def track(options)
      if client_id.present?
        options.merge!(
          context: {
            "Google Analytics" => {
              clientId: client_id
            }
          }
        )
      end
      backend.track(options)
    end
  end
end
