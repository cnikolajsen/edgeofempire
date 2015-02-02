class AddBookIdToArmors < ActiveRecord::Migration
  def change
    add_column :armors, :book_id, :integer

    add_index 'armors', ['book_id'], name: 'index_armors_on_book_id'
  end
end
