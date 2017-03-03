class RemoveUserIdFromSellers < ActiveRecord::Migration
  def change
    remove_column :users, :seller_id, :integer
  end
end
