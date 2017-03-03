class SellersController < ApplicationController

  layout 'company', only: [:show]

  before_action :authorize, only: [:show]
  before_action :authorize_buyer, only: [:index]

  def index
    @sellers = Seller.where(workflow_state: "completed")
  end

  def show
    @seller = Seller.find(params[:id])
    @company = seller_company
    @attachment = Attachment.new
  end

  private

  def authorize
    seller = Seller.find(params[:id])
    if current_seller && current_seller != seller
      flash[:warning] = "You're not authorized to view that page"
      redirect_to signed_out_root_path
    end
  end

  def authorize_buyer
    if current_seller
      flash[:warning] = "You're not authorized to view that page"
      redirect_to signed_out_root_path
    end
  end

  def seller_company
    @seller.seller_company
  end
end
