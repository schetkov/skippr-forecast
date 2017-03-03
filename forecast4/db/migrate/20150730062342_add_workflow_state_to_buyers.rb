class AddWorkflowStateToBuyers < ActiveRecord::Migration
  def change
    add_column :buyers, :workflow_state, :string
  end
end
