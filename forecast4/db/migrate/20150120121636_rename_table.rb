class RenameTable < ActiveRecord::Migration
  def change
    rename_table :financial_attachments, :profit_and_loss_attachments
  end
end
