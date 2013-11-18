class CharacterObligation < ActiveRecord::Base
  #attr_accessible :character_id, :obligation_id
  
  belongs_to :character
  belongs_to :obligation
  
end
