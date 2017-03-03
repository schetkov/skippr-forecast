class AddBsbToBankDetails < ActiveRecord::Migration
  def change
    add_column :bank_details, :bsb_number, :string
  end
end
