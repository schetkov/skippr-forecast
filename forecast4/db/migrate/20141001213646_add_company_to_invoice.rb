class AddCompanyToInvoice < ActiveRecord::Migration
  def change
    add_reference :invoices, :company, index: true
  end
end
