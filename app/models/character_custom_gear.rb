class CharacterCustomGear < ActiveRecord::Base
  belongs_to :character
  validates :description, presence: true
end
