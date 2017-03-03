class ChangeTotalFaceValueToDecimal < ActiveRecord::Migration
  def self.up
    change_column :trades, :total_face_value, :decimal
  end

  def self.down
    change_column :trades, :total_face_value, :integer
  end
end
