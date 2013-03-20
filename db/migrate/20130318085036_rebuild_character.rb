class RebuildCharacter < ActiveRecord::Migration
  def up
    rename_column :characters, :career, :career_id
    rename_column :characters, :species, :race_id
    remove_column :characters, :age
  end

  def down
  end
end
