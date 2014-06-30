class RemoveExperienceFromCharacter < ActiveRecord::Migration
  def change
    remove_column :characters, :experience, :integer
  end
end
