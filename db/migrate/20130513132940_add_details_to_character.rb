class AddDetailsToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :age, :integer
    add_column :characters, :height, :string
    add_column :characters, :build, :string
    add_column :characters, :hair, :string
    add_column :characters, :eyes, :string
    add_column :characters, :notable_features, :text
    add_column :characters, :other, :text
  end
end
