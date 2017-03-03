class AddPaymentStatusNotificationSentColumnToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :payment_status_notification_sent, :datetime
  end
end
