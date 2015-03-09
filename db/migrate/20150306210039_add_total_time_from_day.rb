class AddTotalTimeFromDay < ActiveRecord::Migration
  def change
    add_column :days, :total_time, :integer
  end
end
