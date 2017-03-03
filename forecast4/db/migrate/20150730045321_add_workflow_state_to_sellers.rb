class AddWorkflowStateToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :workflow_state, :string
  end
end
