class Admin::ApproveBuyersController < ApplicationController
  def update
    buyer = Buyer.find(params[:id])

    if buyer.new?
      buyer.confirm!
      flash[:notice] = "#{buyer.name} has been confirmed."
      redirect_to admin_buyers_url(scope: "confirmed")
    end

    if buyer.completed?
      buyer.approve!
      flash[:notice] = "#{buyer.name} has been approved."
      redirect_to admin_buyers_url(scope: "approved")
    end
    # buyer.approval_notification!
  end
end
