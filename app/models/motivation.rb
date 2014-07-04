class Motivation < ActiveRecord::Base
  has_many :character_motivations
  has_many :characters, :through => :character_motivations
  belongs_to :career
end
