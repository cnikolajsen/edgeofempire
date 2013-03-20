class CharacterSkill < ActiveRecord::Base
  attr_accessible :character_id, :ranks, :skill_id
  
  belongs_to :character
  belongs_to :skill
end
