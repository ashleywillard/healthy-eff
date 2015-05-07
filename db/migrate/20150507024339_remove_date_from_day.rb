class RemoveDateFromDay < ActiveRecord::Migration
  def up
    remove_column :days, :date
  end

  def down
    add_column :days, :date, :datetime
  end
end
