class RemoveEnumStateFromSellers < ActiveRecord::Migration
  def change
    remove_column :sellers, :status, :integer
  end
end
