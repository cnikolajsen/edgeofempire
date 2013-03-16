class AddRangeToWeapons < ActiveRecord::Migration
  def change
    add_column :weapons, :range, :string
  end
end
