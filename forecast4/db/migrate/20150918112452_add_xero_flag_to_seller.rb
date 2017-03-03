class AddXeroFlagToSeller < ActiveRecord::Migration
  def change
    add_column :sellers, :error_importing_from_xero, :datetime
  end
end
