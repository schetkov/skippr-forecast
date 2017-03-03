class CreateFinancialAttachments < ActiveRecord::Migration
  def change
    create_table :financial_attachments do |t|
      t.string :file_id
      t.string :file_name
      t.references :seller

      t.timestamps
    end
  end
end
