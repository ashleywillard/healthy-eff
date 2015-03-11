class AddReasonToDays < ActiveRecord::Migration
  def change
    add_column :days, :reason, :text
  end
end
