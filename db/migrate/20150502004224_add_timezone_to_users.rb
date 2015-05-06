class AddTimezoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_timezone, :string, null: false, default: "Pacific Time (US & Canada)"
  end
end
