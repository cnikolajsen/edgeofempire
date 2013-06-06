class AddCharacterState < ActiveRecord::Migration
  def up
    add_column :characters, :aasm_state, :string
  end

  def down
    remove_column :characters, :aasm_state
  end
end
