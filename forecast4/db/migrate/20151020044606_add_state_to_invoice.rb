class AddStateToInvoice < ActiveRecord::Migration
  def change
    remove_column :invoices, :status
    add_column :invoices, :workflow_state, :string, default: "pending"
  end
end
