class CharacterCybernetic < ActiveRecord::Base
  belongs_to :character
  belongs_to :gear
end
