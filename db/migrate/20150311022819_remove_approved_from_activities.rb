class RemoveApprovedFromActivities < ActiveRecord::Migration
  def up
    remove_column :activities, :approved
  end

  def down
    add_column :activities, :approved, :boolean
  end
end
