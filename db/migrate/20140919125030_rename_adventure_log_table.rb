class RenameAdventureLogTable < ActiveRecord::Migration
  def self.up
    rename_table :character_adventure_logs, :adventure_logs
  end

 def self.down
    rename_table :adventure_logs, :character_adventure_logs
 end
end