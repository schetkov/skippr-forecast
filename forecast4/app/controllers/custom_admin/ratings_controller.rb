class CustomAdmin::RatingsController < ApplicationController
  layout "admin"

  def new
    @invoice = Invoice.find(params[:invoice_id])
    @master_ratings = MasterRating.all
  end

  def create
    @invoice = Invoice.find(params[:invoice_id])
    Invoices::RatingApplier.new(@invoice, params[:rating][:master_rating_value]).call
    redirect_to custom_admin_invoice_path(@invoice)
  end
end
