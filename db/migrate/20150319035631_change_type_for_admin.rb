class ChangeTypeForAdmin < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :admin, :boolean
    end
  end

  def down
    change_table :users do |t|
      t.change :admin, :integer
    end
  end
end
