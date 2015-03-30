class CreateMonths < ActiveRecord::Migration
  def change
    create_table :months do |t|
      t.integer :user_id
      t.integer :month
      t.integer :year
      t.boolean :printed_form
      t.boolean :received_form
      t.integer :num_of_days

      t.timestamps
    end
  end
end
