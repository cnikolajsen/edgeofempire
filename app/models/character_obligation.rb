class CharacterObligation < ActiveRecord::Base
  #attr_accessible :character_id, :obligation_id
  default_scope { order('id ASC') }

  belongs_to :character
  belongs_to :obligation

end
