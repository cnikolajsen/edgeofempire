class AddRewardToCharacterObligation < ActiveRecord::Migration
  def change
    add_column :character_obligations, :reward, :string
  end
end
