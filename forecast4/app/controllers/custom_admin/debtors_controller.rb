class CustomAdmin::DebtorsController < ApplicationController
  layout "admin"

  before_action :authenticate_admin_user!

  def index
    if debtor_scope.present?
      @debtors = Debtor.send(debtor_scope).order(created_at: :desc)
    else
      @debtors = Debtor.order(created_at: :desc)
    end
  end

  def show
    @debtor = Debtor.find(params[:id])
  end

  private

  def debtor_scope
    params[:p]
  end
end
