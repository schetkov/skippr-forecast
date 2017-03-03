class Admin::ApproveSellersController < ApplicationController
  def update
    seller = Seller.find(params[:id])

    if seller.new?
      seller.confirm!
      flash[:notice] = "#{seller.name} has been confirmed."
      redirect_to admin_sellers_url(scope: "confirmed")
    end

    # This is redundant?
    if seller.completed?
      seller.approve!
      flash[:notice] = "#{seller.name} has been approved."
      redirect_to admin_sellers_url(scope: "approved")
    end

    # seller.approval_notification!

  end
end
