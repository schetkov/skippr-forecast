class AddCashFlowUserField < ActiveRecord::Migration
  def change
    add_column :sellers, :is_cash_flow_user, :boolean, default: false
  end
end
