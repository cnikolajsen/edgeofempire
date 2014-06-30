class CharacterAdventureLog < ActiveRecord::Base
  belongs_to :character

  default_scope { order('date DESC') }
end
