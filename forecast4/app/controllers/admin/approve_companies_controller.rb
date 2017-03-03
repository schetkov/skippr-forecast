class Admin::ApproveCompaniesController < ApplicationController
  def update
    company = Company.find(params[:id])
    company.touch(:approved)
    flash[:notice] = "#{company.name} has been approved."
    redirect_to admin_companies_url(scope: 'approved')
  end
end
