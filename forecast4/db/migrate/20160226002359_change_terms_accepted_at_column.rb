class ChangeTermsAcceptedAtColumn < ActiveRecord::Migration
  def change
    remove_column :sellers, :terms_accepted_at, :datetime
    add_column :sellers, :accepted_terms, :boolean, default: false
  end
end
