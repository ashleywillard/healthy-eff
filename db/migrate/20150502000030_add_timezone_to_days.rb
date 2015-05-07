class AddTimezoneToDays < ActiveRecord::Migration
  def change
    add_column :days, :timezone, :string
  end
end
