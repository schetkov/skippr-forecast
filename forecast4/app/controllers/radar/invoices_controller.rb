class Radar::InvoicesController < ApplicationController

  before_action :set_scenario, only: [:invoices, :payables]
  before_action :set_invoice, only: [:destroy_invoice]
  before_action :set_payable, only: [:destroy_payable]

  layout 'radar'

  def index
    @invoices = current_seller.default_sales_scenario.invoices_with_settings(base_invoices)
    @payables = current_seller.default_sales_scenario.payables_with_settings(base_payables)

    # In case we want to see projected only.
    if params[:projected]
      @invoices = []
      @payables = []
    end

    @invoices_outstanding = current_seller.invoices.sum(:face_value)
    @payables_outstanding = current_seller.payables.sum(:face_value)

    @customers = current_seller.debtors.select(:id, :legal_business_name)
    @vendors = current_seller.vendors.select(:id, :legal_business_name)
    @scenarios = current_seller.scenarios.select(:id, :title)
  end

  def invoices
    if request.xhr?
      render json: @scenario.invoices_with_settings(base_invoices)
    else
      redirect_to radar_invoices_path
    end
  end

  def payables
    if request.xhr?
      render json: @scenario.payables_with_settings(base_payables)
    else
      redirect_to radar_invoices_path
    end
  end

  def destroy_invoice
    if request.xhr?
      render json: @invoice if @invoice.destroy!
    else
      redirect_to radar_invoices_path
    end
  end

  def destroy_payable
    if request.xhr?
      render json: @payable if @payable.destroy!
    else
      redirect_to radar_invoices_path
    end
  end

private

  def base_invoices
    current_seller.invoices
      .select(:id, :face_value, :debtor_id, :amount_due, :date,
        :due_date, :anticipated_pay_date, :invoice_xero_id)
      .where.not(xero_status: "PAID")
      .order(anticipated_pay_date: :asc)
  end

  def base_payables
    current_seller.payables
      .select(:id, :face_value, :vendor_id, :amount_due, :date,
        :due_date, :anticipated_pay_date, :invoice_xero_id)
      .where.not(xero_status: "PAID")
      .order(anticipated_pay_date: :asc)
  end

protected

  def set_scenario
    @scenario = current_seller.scenarios.find(params[:scenario_id])
  end

  def set_invoice
    @invoice = current_seller.invoices.find(params[:invoice_id])
  end

  def set_payable
    @payable = current_seller.payables.find(params[:payable_id])
  end

end
