class AddUserToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :user, :string
  end
end
