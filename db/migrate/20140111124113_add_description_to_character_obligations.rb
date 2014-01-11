class AddDescriptionToCharacterObligations < ActiveRecord::Migration
  def change
    add_column :character_obligations, :description, :text
    add_column :character_obligations, :magnitude, :integer
  end
end
