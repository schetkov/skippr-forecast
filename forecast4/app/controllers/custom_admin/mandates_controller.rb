class CustomAdmin::MandatesController < ApplicationController
  layout "admin"

  before_action :authenticate_admin_user!

  def new
    @mandate = Mandate.new
  end

  def create
    @mandate = Mandate.new(mandate_params)
    if @mandate.save
      redirect_to custom_admin_buyer_path(@mandate.buyer)
    else
      render "new"
    end
  end

  private

  def mandate_params
    params.require(:mandate).permit(
      :buyer_id,
      :debtor_id,
      :percentage_of_funds_for_investor,
      :percentage_of_each_invoice
    )
  end
end
