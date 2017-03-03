class AddColumnsToScenarioInvoiceTable < ActiveRecord::Migration
  def change
    add_column :scenario_invoices, :due_date, :date
    add_column :scenario_invoices, :anticipated_pay_date, :date
  end
end
