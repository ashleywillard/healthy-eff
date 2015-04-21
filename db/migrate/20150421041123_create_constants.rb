class CreateConstants < ActiveRecord::Migration
  def change
    create_table :constants do |t|
      t.integer :curr_rate

      t.timestamps
    end
  end
end
