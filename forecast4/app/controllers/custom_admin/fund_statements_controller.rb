class CustomAdmin::FundStatementsController < ApplicationController
  layout "admin"

  def new
    @fund_statement = FundStatement.new
  end

  def create
    @buyer = Buyer.find(params[:fund_statement][:buyer_id])
    @fund_statement = Funds::FundDepositor.new(@buyer, fund_statement_params).call
    if @fund_statement.save
      redirect_to custom_admin_buyer_path(@buyer)
    else
      render "new"
    end
  end


  private

  def fund_statement_params
    params.require(:fund_statement).permit(
      :buyer_id,
      :total_cash
    )
  end
end
