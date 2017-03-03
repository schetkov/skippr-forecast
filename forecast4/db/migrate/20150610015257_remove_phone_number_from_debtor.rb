class RemovePhoneNumberFromDebtor < ActiveRecord::Migration
  def change
    remove_column :debtors, :phone_number, :string
  end
end
