class AddCreditsAndExperienceToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :credits, :integer
    add_column :characters, :experience, :integer
  end
end
