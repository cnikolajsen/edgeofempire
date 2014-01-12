class CharacterMotivation < ActiveRecord::Base
  default_scope { order('id ASC') }

  belongs_to :character
  belongs_to :motivation
end
