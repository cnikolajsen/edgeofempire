class AddTalentOptionToCharacterTalent < ActiveRecord::Migration
  def change
    add_column :character_talents, :talent_1_1_options, :string
    add_column :character_talents, :talent_1_2_options, :string
    add_column :character_talents, :talent_1_3_options, :string
    add_column :character_talents, :talent_1_4_options, :string
    add_column :character_talents, :talent_2_1_options, :string
    add_column :character_talents, :talent_2_2_options, :string
    add_column :character_talents, :talent_2_3_options, :string
    add_column :character_talents, :talent_2_4_options, :string
    add_column :character_talents, :talent_3_1_options, :string
    add_column :character_talents, :talent_3_2_options, :string
    add_column :character_talents, :talent_3_3_options, :string
    add_column :character_talents, :talent_3_4_options, :string
    add_column :character_talents, :talent_4_1_options, :string
    add_column :character_talents, :talent_4_2_options, :string
    add_column :character_talents, :talent_4_3_options, :string
    add_column :character_talents, :talent_4_4_options, :string
    add_column :character_talents, :talent_5_1_options, :string
    add_column :character_talents, :talent_5_2_options, :string
    add_column :character_talents, :talent_5_3_options, :string
    add_column :character_talents, :talent_5_4_options, :string
  end
end
