class RemoveColumnsFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :company_name, :string
    remove_column :users, :phone_number, :string
  end
end
