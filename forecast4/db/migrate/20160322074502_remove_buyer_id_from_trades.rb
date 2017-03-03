class RemoveBuyerIdFromTrades < ActiveRecord::Migration
  def change
    remove_column :trades, :buyer_id, :integer
  end
end
