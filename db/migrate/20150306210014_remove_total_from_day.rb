class RemoveTotalFromDay < ActiveRecord::Migration
  def up
    remove_column :days, :total
  end

  def down
    add_column :days, :total, :integer
  end
end
