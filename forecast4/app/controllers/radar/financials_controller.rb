class Radar::FinancialsController < ApplicationController
  before_action :set_scenario

  def invoices
    if request.xhr?
      record = @scenario.scenario_invoices.find_by(invoice_id: params[:scenario_invoice][:invoice_id])
      record = if record.present?
        record.update!(scenario_invoice_params)
        record.reload
      else
        @scenario.scenario_invoices.create!(scenario_invoice_params)
      end
      render json: record
    else
      redirect_to radar_invoices_path
    end
  end

  def payables
    if request.xhr?
      record = @scenario.scenario_payables.find_by(payable_id: params[:scenario_payable][:payable_id])
      record = if record.present?
        record.update!(scenario_payable_params)
        record.reload
      else
        @scenario.scenario_payables.create!(scenario_payable_params)
      end
      render json: record
    else
      redirect_to radar_invoices_path
    end
  end

protected

  def set_scenario
    @scenario = current_seller.scenarios.find(params[:scenario_id])
  end

  def scenario_invoice_params
    params.require(:scenario_invoice).permit(:invoice_id, :due_date, :anticipated_pay_date, :is_sold, :is_hidden)
  end

  def scenario_payable_params
    params.require(:scenario_payable).permit(:payable_id, :anticipated_pay_date, :is_hidden)
  end

end
