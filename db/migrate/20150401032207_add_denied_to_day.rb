class AddDeniedToDay < ActiveRecord::Migration
  def change
    add_column :days, :denied, :boolean
  end
end
