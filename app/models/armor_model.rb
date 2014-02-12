class ArmorModel < ActiveRecord::Base
  belongs_to :armor
  belongs_to :character_armor
end
