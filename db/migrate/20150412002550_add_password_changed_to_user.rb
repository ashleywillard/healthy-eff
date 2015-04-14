class AddPasswordChangedToUser < ActiveRecord::Migration
  def change
    add_column :users, :password_changed, :boolean, :default => false
  end
end
