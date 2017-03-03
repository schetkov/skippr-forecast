module Sessions
  class SessionRedirector
    include Rails.application.routes.url_helpers

    def initialize(user)
      @user = user
      @buyer = user.buyer
      @seller = user.seller
    end

    def call
      if user.admin?
        admin_dashboard_path
      else
        find_redirect_path
      end
    end

    private

    attr_reader :user, :buyer, :seller

    def find_redirect_path
      send("#{buyer_or_seller}_registration_path")
    end

    def buyer_or_seller
      user_type.class.to_s.downcase
    end

    def user_type
      buyer || seller
    end

    def seller_registration_path
      if seller.cash_flow_user?
        seller_cash_flow_urls[seller.workflow_state.to_sym]
      else
        seller_urls[seller.workflow_state.to_sym]
      end
    end

    def buyer_registration_path
      buyer_urls[buyer.workflow_state.to_sym]
    end

    def seller_urls
      {
        business_registration: business_wizard_path,
        customer_registration: customer_wizard_path,
        terms_registration: terms_wizard_path,
        completed: seller_dashboard_path
      }
    end

    def seller_cash_flow_urls
      {
        business_registration: new_cash_flow_user_xero_path,
        completed: radar_invoices_path
      }
    end

    def buyer_urls
      {
        confirmed: signed_out_root_path,
        completed: signed_out_root_path,
        approved: buyer_dealboard_path
      }
    end
  end
end
