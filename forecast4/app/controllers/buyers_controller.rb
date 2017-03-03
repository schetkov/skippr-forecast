class BuyersController < ApplicationController

  layout 'company', only: [:show]

  def update
    if current_buyer.update(buyer_params)
      redirect_to investor_registration_path(buyer_params)
    else
      render '/registration/investor_types/edit'
    end
  end

  private

  def buyer_params
    params.require(:buyer).permit(:investor_type)
  end
end
