class AddLiveStatsToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :strain, :integer, default: 0
    add_column :characters, :wounds, :integer, default: 0
    add_column :characters, :staggered, :boolean, default: false
    add_column :characters, :immobilized, :boolean, default: false
    add_column :characters, :disoriented, :boolean, default: false
  end
end
