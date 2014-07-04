class Obligation < ActiveRecord::Base
  has_many :character_obligations
  has_many :characters, :through => :character_obligations
  belongs_to :career
end
