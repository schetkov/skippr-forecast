class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file_id
      t.string :file_name
      t.integer :file_type
      t.references :attachable, polymorphic: true

      t.timestamps null: false
    end
  end
end
