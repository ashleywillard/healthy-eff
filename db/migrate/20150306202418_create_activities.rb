class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :type
      t.integer :duration
      t.boolean :approved

      t.timestamps
    end
  end
end
