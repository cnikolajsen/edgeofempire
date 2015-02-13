class StarshipCategory < ActiveRecord::Base
  has_many :starships
end
