class RemoveTypeFromActivities < ActiveRecord::Migration
  def up
    remove_column :activities, :type
  end

  def down
    add_column :activities, :type, :string
  end
end
