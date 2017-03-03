class RemoveEnumStateFromBuyers < ActiveRecord::Migration
  def change
    remove_column :buyers, :status, :integer
  end
end
