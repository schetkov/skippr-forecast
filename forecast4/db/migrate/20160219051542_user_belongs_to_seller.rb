class UserBelongsToSeller < ActiveRecord::Migration
  def change
    add_reference :users, :seller, index: true

    Rake::Task["users:belongs_to_seller"].invoke

    remove_column :sellers, :user_id, :integer
  end
end
