class AddAccountingPlatformToSeller < ActiveRecord::Migration
  def change
    add_column :sellers, :accounting_platform, :string
  end
end
