class AddDateToDay < ActiveRecord::Migration
  def change
    add_column :days, :date, :date
  end
end
