class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.integer :duration
      t.boolean :approved

      t.timestamps
    end
  end

  def down
  	drop_table :activities
  end
  
end
