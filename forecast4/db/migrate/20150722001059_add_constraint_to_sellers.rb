class AddConstraintToSellers < ActiveRecord::Migration
  def change
    change_column_null :sellers, :user_id, false
  end
end
