class AddMonthidToDays < ActiveRecord::Migration
  def change
    add_column :days, :month_id, :integer
  end
end
