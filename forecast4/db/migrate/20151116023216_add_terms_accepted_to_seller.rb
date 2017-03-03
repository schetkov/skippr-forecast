class AddTermsAcceptedToSeller < ActiveRecord::Migration
  def change
    add_column :sellers, :terms_accepted_at, :datetime
  end
end
