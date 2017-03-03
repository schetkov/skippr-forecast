class XeroController < ApplicationController
  layout "registration"

  def new
    clear_xero_errors
  end

  def new_cash_flow_user
    clear_xero_errors
  end

private

  def clear_xero_errors
    if !!current_seller.error_importing_from_xero
      current_seller.update(error_importing_from_xero: nil)
    end
  end

end
