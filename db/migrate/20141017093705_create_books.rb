class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.string :system
      t.string :isbn
      t.string :category
      t.string :ffg_sku
      t.string :cover_art_url
      t.string :slug

      t.timestamps
    end

    add_index "books", ["slug"], name: "index_books_on_slug", unique: true, using: :btree
  end
end
