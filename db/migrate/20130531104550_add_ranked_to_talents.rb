class AddRankedToTalents < ActiveRecord::Migration
  def change
    add_column :talents, :ranked, :boolean
  end
end
