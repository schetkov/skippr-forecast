class AddXeroColumnsToSellerCompany < ActiveRecord::Migration
  def change
    add_column :seller_companies, :legal_name, :string
    add_column :seller_companies, :pays_tax, :boolean
    add_column :seller_companies, :version, :string
    add_column :seller_companies, :base_currency, :string
    add_column :seller_companies, :registration_number, :string
    add_column :seller_companies, :tax_number, :string
    add_column :seller_companies, :financial_year_end_day, :string
    add_column :seller_companies, :financial_year_end_month, :string
    add_column :seller_companies, :organisation_type, :string
    add_column :seller_companies, :short_code, :string
    add_column :seller_companies, :addresses, :json
    add_column :seller_companies, :phones, :json
    add_column :seller_companies, :external_links, :string
  end
end
