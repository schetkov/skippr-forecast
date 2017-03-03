class RemoveBankDetailsName < ActiveRecord::Migration
  def change
    remove_column :bank_details, :name
  end
end
