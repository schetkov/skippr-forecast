class AddBasicInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company_name, :string
    add_column :users, :phone_number, :string
  end
end
