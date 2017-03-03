class CustomAdmin::BuyersController < ApplicationController
  layout "admin"

  before_action :authenticate_admin_user!

  def index
    @buyers = Buyer.order(created_at: :desc)
  end

  def show
    @buyer = Buyer.find(params[:id])
    @mandates = @buyer.mandates
  end

  def new
    @buyer = Buyer.new
  end

  def create
    @buyer = Buyer.new(buyer_params)
    @buyer.workflow_state = "confirmed"
    if @buyer.save
      redirect_to custom_admin_buyer_path(@buyer)
    else
      render "new"
    end
  end

  def edit
    @buyer = Buyer.find(params[:id])
  end

  def update
    @buyer = Buyer.find(params[:id])
    if @buyer.update(buyer_params)
      redirect_to custom_admin_buyer_path(@buyer)
    else
      render "edit"
    end
  end

  private

  def buyer_params
    params.require(:buyer).permit(
      :investor_type,
      user_attributes: [:id, :account_type, :name, :email, :password],
      buyer_company_attributes: [
        :id,
        :name,
        :phone_number,
        :acn,
        :abn,
        :description,
        :afsl_number
      ]
    )
  end
end
