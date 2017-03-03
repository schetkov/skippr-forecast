class UsePolymorphismForBuyerSellerRelationship < ActiveRecord::Migration
  def change
    remove_column :buyers, :user_id, :integer
  end
end
