class Radar::ScenariosController < ApplicationController
  before_action :set_scenario, only: [:update, :destroy]

  def create
    if request.xhr?
      render json: current_seller.scenarios.create!(scenario_params)
    else
      redirect_to radar_invoices_path
    end
  end

  def update
    if request.xhr?
      render json: @scenario.reload if @scenario.update!(scenario_params)
    else
      redirect_to radar_invoices_path
    end
  end

  def destroy
    if request.xhr?
      render json: @scenario.destroy!
    else
      redirect_to radar_invoices_path
    end
  end

protected

  def set_scenario
    @scenario = current_seller.scenarios.find(params[:id])
  end

  def scenario_params
    params.require(:scenario).permit(:title)
  end


end
