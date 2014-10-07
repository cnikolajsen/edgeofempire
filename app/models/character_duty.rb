class CharacterDuty < ActiveRecord::Base
  default_scope { order('id ASC') }

  belongs_to :character
  belongs_to :duty

end
