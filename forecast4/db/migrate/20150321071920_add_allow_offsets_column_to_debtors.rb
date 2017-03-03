class AddAllowOffsetsColumnToDebtors < ActiveRecord::Migration
  def change
    add_column :debtors, :allow_offsets, :string, default: 'no'
  end
end
