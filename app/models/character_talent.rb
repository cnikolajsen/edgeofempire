class CharacterTalent < ActiveRecord::Base
  attr_accessible :character_id, :talent_id, :talent_tree_id
  
  belongs_to :character
  belongs_to :talent
end
