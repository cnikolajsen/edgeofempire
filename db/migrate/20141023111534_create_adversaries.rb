class CreateAdversaries < ActiveRecord::Migration
  def change
    create_table :adversaries do |t|
      t.string :name
      t.text :description
      t.integer :brawn
      t.integer :agility
      t.integer :intellect
      t.integer :cunning
      t.integer :willpower
      t.integer :presence
      t.integer :soak
      t.integer :defense_ranged
      t.integer :defense_melee
      t.integer :wounds
      t.integer :strain
      t.integer :race_id
      t.text :abilities
      t.string :image_url
      t.integer :book_id
      t.integer :page
      t.string :adversary_type
      t.string :slug

      t.timestamps
    end

    add_index 'adversaries', ['slug'], name: 'index_adversaries_on_slug', unique: true, using: :btree
  end
end
