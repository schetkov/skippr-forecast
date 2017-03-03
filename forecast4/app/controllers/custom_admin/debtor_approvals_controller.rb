class CustomAdmin::DebtorApprovalsController < ApplicationController
  before_action :authenticate_admin_user!

  def create
    debtor = Debtor.find(params[:id])
    debtor.approved!
    flash[:success] = "Customer #{debtor.id} has been approved!"
    redirect_to custom_admin_debtor_path(debtor)
  end
end
