class AddColumnsForLegalsToSellerCompany < ActiveRecord::Migration
  def change
    add_column :seller_companies, :directors_name, :string
    add_column :seller_companies, :directors_email, :string
  end
end
