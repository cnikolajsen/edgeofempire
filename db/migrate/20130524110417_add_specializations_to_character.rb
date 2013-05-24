class AddSpecializationsToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :specialization_1, :integer
    add_column :characters, :specialization_2, :integer
    add_column :characters, :specialization_3, :integer
  end
end
