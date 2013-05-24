class RemoveUnusedFieldsFromTalents < ActiveRecord::Migration
  def up
    remove_column :talents, :ranked
    remove_column :talents, :cost
    remove_column :talents, :talent_type
  end
end
