class AddApprovedToDays < ActiveRecord::Migration
  def change
    add_column :days, :approved, :boolean
  end
end
