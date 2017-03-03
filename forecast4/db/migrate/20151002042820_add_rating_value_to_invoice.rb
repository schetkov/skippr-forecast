class AddRatingValueToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :rating_value, :string
  end
end
