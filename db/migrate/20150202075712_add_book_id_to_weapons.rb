class AddBookIdToWeapons < ActiveRecord::Migration
  def change
    add_column :weapons, :book_id, :integer

    add_index 'weapons', ['book_id'], name: 'index_weapons_on_book_id'
  end
end
