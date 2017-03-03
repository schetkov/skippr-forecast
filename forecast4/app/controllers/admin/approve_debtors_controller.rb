class Admin::ApproveDebtorsController < ApplicationController
  def update
    debtor = Debtor.find(params[:id])
    debtor.approved!
    flash[:notice] = "#{debtor.legal_business_name} has been approved as a debtor."
    redirect_to admin_debtors_url(scope: 'approved')
  end
end
