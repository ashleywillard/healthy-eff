class AddWorkoutrateToMonth < ActiveRecord::Migration
  def change
    add_column :months, :work_rate, :integer
  end
end
