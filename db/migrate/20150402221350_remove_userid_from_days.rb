class RemoveUseridFromDays < ActiveRecord::Migration
  def up
    remove_column :days, :user_id
  end

  def down
    add_column :days, :user_id, :integer
  end
end
