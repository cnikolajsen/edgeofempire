class CharacterGear < ActiveRecord::Base
  #attr_accessible :character_id, :gear_id, :qty
  
  belongs_to :character
  belongs_to :gear
  
end
