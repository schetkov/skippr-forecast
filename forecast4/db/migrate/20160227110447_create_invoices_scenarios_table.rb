class CreateInvoicesScenariosTable < ActiveRecord::Migration
  def change
    create_table :scenario_invoices do |t|
      t.belongs_to :invoice, index: true
      t.belongs_to :cash_flow_scenario, index: true
      t.boolean :is_sold
      t.boolean :is_hidden
    end
  end
end
