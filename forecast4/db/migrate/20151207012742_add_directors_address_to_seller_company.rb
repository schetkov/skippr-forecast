class AddDirectorsAddressToSellerCompany < ActiveRecord::Migration
  def change
    add_column :seller_companies, :directors_address, :string
    add_column :sellers, :dob, :datetime
    add_column :sellers, :drivers_license_number, :string
    add_column :sellers, :is_authorised_officer, :boolean
  end
end
