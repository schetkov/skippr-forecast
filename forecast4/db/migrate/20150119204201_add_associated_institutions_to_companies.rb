class AddAssociatedInstitutionsToCompanies < ActiveRecord::Migration
  def change
    add_column :seller_companies, :associated_institutions, :string
  end
end
